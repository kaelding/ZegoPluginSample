//
//  MessaesViewModel.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/9.
//

import Foundation
import ZIM
import UIKit

class MessaeListViewModel: NSObject {

    /// The handle queue when receive or query messages.
    var handleMessageQueue = DispatchQueue(label: "com.zegocloud.imkit.handleMessageQueue")

    private(set) var conversationID: String
    private(set) var conversationType: ZIMConversationType

    @Observable var messageViewModels: [MessageViewModel] = []
    @Observable var isReceiveNewMessage: Bool = false
    @Observable var isSendingNewMessage: Bool = false
    @Observable var isHistoryMessageLoaded: Bool = false
    @Observable var deleteMessages: [MessageViewModel] = []
    @Observable var connectionEvent: ZIMConnectionEvent = .success

    var groupMemberDict = ThreadSafeDictionary<String, ZIMKitGroupMember>()

    var otherUser: ZIMKitUserInfo?

    var isFirstLoad: Bool = true
    var isLoadingData: Bool = false
    var isNoMoreMsg: Bool = false
    var isShowCheckBox: Bool = false

    init(conversationID: String, _ conversationType: ZIMConversationType) {
        self.conversationID = conversationID
        self.conversationType = conversationType
        super.init()
        ZIMKit.registerZIMKitDelegate(self)
    }
}

// MARK: - Public
extension MessaeListViewModel {
    
    func getMessageList(_ callback: ((ZIMError) -> Void)?) {
        isLoadingData = true
        ZIMKit.getMessageList(with: conversationID, type: conversationType) { [weak self] messages, error in
            if error.code != .success {
                callback?(error)
                self?.isLoadingData = false
                return
            }
            guard let self = self else { return }
            self.handleMessageQueue.async {
                self.handleLoadedHistoryMessages(messages)
                DispatchQueue.main.async {
                    callback?(error)
                    self.isLoadingData = false
                }
            }
        }
    }
    
    func loadMoreMessages(_ callback: ((ZIMError) -> Void)?) {
        if isLoadingData { return }
        isLoadingData = true
        ZIMKit.loadMoreMessage(with: conversationID, type: conversationType) { [weak self] error in
            self?.isLoadingData = false
            callback?(error)
        }
    }

    
    /// Only use when conversation type is `peer`, to query the user info.
    func queryOtherUserInfo(_ callback: ((ZIMError) -> Void)? = nil) {
        ZIMKit.queryUserInfo(by: conversationID) { [weak self] userInfo, _, error in
            self?.otherUser = userInfo
            self?.updateOtherUserInfoToMessages()
            callback?(error)
        }
    }

    /// Only use when conversation type is `group`, to query the group info.
    func queryGroupInfo(_ callback: ((ZIMKitGroupInfo?, ZIMError) -> Void)? = nil) {
        ZIMKit.queryGroupInfo(by: conversationID) { groupInfo, error in
            callback?(groupInfo, error)
        }
    }

    func clearConversationUnreadMessageCount() {
        ZIMKit.clearUnreadCount(for: conversationID, type: conversationType)
    }

    func downloadMediaMessage(_ viewModel: MediaMessageViewModel, callback: ((ZIMError) -> Void)? = nil) {
        if viewModel.isDownloading { return }
        viewModel.isDownloading = true
        let message = viewModel.message
        ZIMKit.downloadMediaFile(with: message) { error in
            viewModel.isDownloading = false
            if error.code == .success {
                print("✅Download File Success: \(message.fileName), localID: \(message.info.localMessageID)")
            } else {
                print("❌Download File Failed: \(message.fileName), localID: \(message.info.localMessageID)")
            }
            callback?(error)
        }
    }

    // MARK: - Delete Message
    func deleteMessages(_ viewModels: [MessageViewModel], callback: ((ZIMError) -> Void)? = nil) {
        let messages = viewModels.compactMap({ $0.message })
        if messages.count == 0 { return }
        ZIMKit.deleteMessage(messages) { error in
            callback?(error)
        }
        DispatchQueue.global().async {
            for message in messages {
                if message.type == .image {
                    ImageCache.removeCache(for: message.imageContent.thumbnailDownloadUrl)
                    ImageCache.removeCache(for: message.imageContent.largeImageDownloadUrl)
                    ImageCache.removeCache(for: message.imageContent.fileLocalPath)
                    if FileManager.default.fileExists(atPath: message.fileLocalPath) {
                        try? FileManager.default.removeItem(atPath: message.fileLocalPath)
                    }
                } else if FileManager.default.fileExists(atPath: message.fileLocalPath) {
                    try? FileManager.default.removeItem(atPath: message.fileLocalPath)
                }
            }
        }
    }
    
    func queryGroupMemberInfo(_ userID: String) {
        
    }
}

// MARK: - Private
extension MessaeListViewModel {
    
    private func handleReceiveNewMessages(_ messageList: [ZIMKitMessage]) {

        handleMessageQueue.async {
            // need Ascending
            let messageList = messageList.sorted { $0.info.timestamp < $1.info.timestamp }

            var newMessages: [MessageViewModel] = []
            var lastMessage = self.messageViewModels.last
            for msg in messageList {
                let model = MessageViewModelFactory.createMessage(with: msg)
                model.setNeedShowTime(lastMessage?.message.info.timestamp)
                model.setCellHeight()
                self.updateMessageUserInfo(with: model)
                newMessages.append(model)
                lastMessage = model
                // auto download files
                self.autoDownloadFiles(with: model)
            }
            self.messageViewModels.append(contentsOf: newMessages)

            DispatchQueue.main.async {
                self.isReceiveNewMessage = true
            }
        }

        clearConversationUnreadMessageCount()
    }
    
    private func handleSentCallback(_ message: ZIMKitMessage) {
        
        guard let index = messageViewModels.firstIndex(where: { $0.message === message }) else {
            return
        }
        let viewModel = messageViewModels[index]
        if index - 1 >= 0 {
            let lastViewModel = messageViewModels[index-1]
            viewModel.setNeedShowTime(lastViewModel.message.info.timestamp)
        }
        viewModel.reSetCellHeight()
        updateMessageUserInfo(with: viewModel)
        
        isSendingNewMessage = true
        
        // delete local image if send success
        if message.type == .image {
            try? FileManager.default.removeItem(atPath: message.fileLocalPath)
        }
    }
    
    private func handleLoadedHistoryMessages(_ messages: [ZIMKitMessage]) {
        var newMessages: [MessageViewModel] = []
        for message in messages {
            let viewModel = MessageViewModelFactory.createMessage(with: message)
            viewModel.setNeedShowTime(newMessages.last?.message.info.timestamp)
            viewModel.setCellHeight()
            updateMessageUserInfo(with: viewModel)
            newMessages.append(viewModel)
            autoDownloadFiles(with: viewModel)
        }
        if let lastMessageVM = messageViewModels.first {
            lastMessageVM.setNeedShowTime(newMessages.last?.message.info.timestamp)
            lastMessageVM.setCellHeight()
        }
        messageViewModels = newMessages + messageViewModels
    }
    
    private func updateMessageUserInfo(with viewModel: MessageViewModel) {
        let message = viewModel.message
        if message.info.conversationType == .group {
            let member = groupMemberDict[message.info.senderUserID]
            viewModel.senderUsername = member?.name
            viewModel.senderUserAvatar = member?.avatarUrl
        } else if message.info.conversationType == .peer {
            if message.info.direction == .send {
                viewModel.senderUsername = ZIMKit.currentUser?.name
                viewModel.senderUserAvatar = ZIMKit.currentUser?.avatarUrl
            } else {
                viewModel.senderUsername = otherUser?.name
                viewModel.senderUserAvatar = otherUser?.avatarUrl
            }
        }
    }

    private func updateOtherUserInfoToMessages() {
        let toUpdateMessages = messageViewModels.filter { $0.message.info.senderUserID == otherUser?.id }
        toUpdateMessages.forEach { msg in
            msg.senderUsername = otherUser?.name
            msg.senderUserAvatar = otherUser?.avatarUrl
        }
    }

    private func autoDownloadFiles(with viewModel: MessageViewModel) {
        let message = viewModel.message
        if message.type != .audio && message.type != .file { return }
        if FileManager.default.fileExists(atPath: message.fileLocalPath) { return }
        if message.fileSize > 1024 * 1024 * 10 { return }
        if message.fileDownloadUrl.count == 0 { return }

        guard let viewModel = viewModel as? MediaMessageViewModel else { return }
        downloadMediaMessage(viewModel) { [weak self] error in
            if error.code != .success {
                //                #warning("The simple retry logic, will remove in future.")
                /// redownload after 5s, if failed.
                DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
                    self?.autoDownloadFiles(with: viewModel)
                }
            }
        }
    }
}

// MARK: - ZIMEventHandler
extension MessaeListViewModel: ZIMKitDelegate {
    
    func onConnectionStateChange(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent) {
        self.connectionEvent = event
    }
    
    func onMessageReceived(_ conversationID: String, type: ZIMConversationType, messages: [ZIMKitMessage]) {
        if self.conversationID != conversationID || self.conversationType != type {
            return
        }
        if messages.count == 0 { return }
        handleReceiveNewMessages(messages)
    }
    
    func onHistoryMessageLoaded(_ conversationID: String, type: ZIMConversationType, messages: [ZIMKitMessage]) {
        if self.conversationID != conversationID || self.conversationType != type {
            return
        }
        if messages.count == 0 {
            isNoMoreMsg = true
            return
        }
        handleMessageQueue.async {
            self.handleLoadedHistoryMessages(messages)
            DispatchQueue.main.async {
                self.isHistoryMessageLoaded = true
            }
        }
    }
    
    func onMessageDeleted(_ conversationID: String, type: ZIMConversationType, messages: [ZIMKitMessage]) {
        if self.conversationID != conversationID || self.conversationType != type {
            return
        }
        deleteMessages = messageViewModels.filter({ messages.contains($0.message) })
        messageViewModels = messageViewModels.filter({ !messages.contains($0.message) })
    }
    
    func onMessageSentStatusChanged(_ message: ZIMKitMessage) {
        handleSentCallback(message)
    }
    
    func onMediaMessageUploadingProgressUpdated(_ message: ZIMKitMessage) {
        
    }
    
    func onMediaMessageDownloadingProgressUpdated(_ message: ZIMKitMessage) {
        
    }
}
