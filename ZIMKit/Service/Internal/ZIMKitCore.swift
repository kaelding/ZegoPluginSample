//
//  ZIMKitCore.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/8.
//

import Foundation
import ZIM
import ZegoSignalingPlugin

class ZIMKitCore: NSObject {
    static let shared = ZIMKitCore()
    
    var zim: ZIM? = nil
    
    fileprivate(set) var userInfo: UserInfo?
    
    var conversations: [ZIMKitConversation] = []
    
    var messageList: MessageList = MessageList()
    
    private var isLoadedAllConversations = false
    
    let delegates: NSHashTable<ZIMKitDelegate> = NSHashTable(options: .weakMemory)
    
    func initWith(appID: UInt32, appSign: String) {
        ZegoSignalingPlugin.shared.initWith(appID: appID, appSign: appSign)
        zim = ZIM.shared()
        ZegoSignalingPlugin.shared.registerZIMEventHandler(self)
    }
    
    func registerZIMKitDelegate(_ delegate: ZIMKitDelegate) {
        delegates.add(delegate)
    }
    
    // MARK: - User
    func connectUser(userInfo: UserInfo, callback: ConnectUserCallback? = nil) {
        assert(zim != nil, "Must create ZIM first!!!")
        let zimUserInfo = ZIMUserInfo()
        zimUserInfo.userID = userInfo.id
        zimUserInfo.userName = userInfo.name
        zim?.login(with: zimUserInfo) { [weak self] error in
            if error.code == .success {
                self?.userInfo = userInfo
            }
            if let userAvatarUrl = userInfo.avatarUrl {
                self?.updateUserAvatarUrl(userAvatarUrl, callback: nil)
            }
            callback?(error)
        }
    }
    
    func disconnectUser() {
        zim?.logout()
        conversations.removeAll()
        messageList.clear()
    }
    
    func queryUserInfo(by userID: String,
                       isQueryFromServer: Bool,
                       callback: QueryUserCallback? = nil) {
        let config = ZIMUsersInfoQueryConfig()
        config.isQueryFromServer = isQueryFromServer
        zim?.queryUsersInfo(by: [userID], config: config, callback: { fullInfos, errorUserInfos, error in
            var userInfo: UserInfo?
            if let fullUserInfo = fullInfos.first {
                userInfo = UserInfo(fullUserInfo)
            }
            let errorUserInfo = errorUserInfos.first
            callback?(userInfo, errorUserInfo, error)
        })
    }
    
    func updateUserAvatarUrl(_ avatarUrl: String,
                             callback: UserAvatarUrlUpdateCallback? = nil) {
        zim?.updateUserAvatarUrl(avatarUrl, callback: { url, error in
            self.userInfo?.avatarUrl = url
            callback?(url, error)
        })
    }
    
    // MARK: - Group
    func createGroup(with groupName: String,
                     groupID: String,
                     userIDs: [String],
                     callback: CreateGroupCallback? = nil) {
        let info = ZIMGroupInfo()
        info.groupName = groupName
        info.groupID = groupID
        zim?.createGroup(with: info, userIDs: userIDs, callback: { fullInfo, _, errorUserList, error in
            let info = GroupInfo(with: fullInfo)
            callback?(info, errorUserList, error)
        })
    }
    
    func joinGroup(by groupID: String, callback: JoinGroupCallback? = nil) {
        zim?.joinGroup(by: groupID, callback: { fullInfo, error in
            let info = GroupInfo(with: fullInfo)
            callback?(info, error)
        })
    }
    
    func leaveGroup(by groupID: String, callback: LeaveGroupCallback? = nil) {
        zim?.leaveGroup(by: groupID, callback: { groupID, error in
            callback?(error)
        })
    }
    
    func inviteUsersToJoinGroup(with inviteUserIDs: [String],
                                groupID: String,
                                callback: InviteUsersToJoinGroupCallback? = nil) {
        zim?.inviteUsersIntoGroup(with: inviteUserIDs, groupID: groupID, callback: { groupID, groupMemberInfos, errorUserInfos, error in
            let members = groupMemberInfos.compactMap { GroupMember(with: $0) }
            callback?(members, errorUserInfos, error)
        })
    }
    
    func queryGroupInfo(by groupID: String,
                        callback: QueryGroupInfoCallback? = nil) {
        zim?.queryGroupInfo(by: groupID, callback: { fullInfo, error in
            let groupInfo = GroupInfo(with: fullInfo)
            callback?(groupInfo, error)
        })
    }
    
    func queryGroupMemberInfo(by userID: String,
                              groupID: String,
                              callback: QueryGroupMemberInfoCallback? = nil) {
        zim?.queryGroupMemberInfo(by: userID, groupID: groupID, callback: { _, zimMemberInfo, error in
            let groupMember = GroupMember(with: zimMemberInfo)
            callback?(groupMember, error)
        })
    }
    
    // MARK: - Conversation
    func getConversationList(_ callback: GetConversationListCallback? = nil) {
        if conversations.count > 0 {
            let error = ZIMError()
            error.code = .success
            callback?(conversations, error)
        } else {
            loadMoreConversation(false) { error in
                callback?(self.conversations, error)
            }
        }
    }
    func deleteConversation(by conversationID: String,
                            type: ZIMConversationType,
                            callback: DeleteConversationCallback? = nil) {
        let index = self.conversations.firstIndex { con in
            con.id == conversationID && con.type == type
        }
        if let index = index {
            self.conversations.remove(at: index)
        }
        
        let config = ZIMConversationDeleteConfig()
        config.isAlsoDeleteServerConversation = true
        zim?.deleteConversation(by: conversationID,
                                conversationType: type,
                                config: config, callback: { conversationID, type, error in
            callback?(error)
            
            for delegate in self.delegates.allObjects {
                delegate.onConversationListChanged?(self.conversations)
            }
        })
    }
    
    func clearUnreadCount(for conversationID: String,
                          type: ZIMConversationType,
                          callback: ClearUnreadCountCallback? = nil) {
        zim?.clearConversationUnreadMessageCount(for: conversationID, conversationType: type, callback: { _, _, error in
            callback?(error)
        })
    }
    
    func loadMoreConversation(_ isCallbackListChanged: Bool = true,
                              callback: LoadMoreConversationCallback? = nil) {
        if isLoadedAllConversations { return }
        let quryConfig = ZIMConversationQueryConfig()
        quryConfig.count = 100
        quryConfig.nextConversation = conversations.last?.zim
        zim?.queryConversationList(with: quryConfig, callback: { zimConversations, error in
            if error.code != .success {
                callback?(error)
                return
            }
            
            self.isLoadedAllConversations = zimConversations.count < quryConfig.count
            
            let newConversations = zimConversations.compactMap({ ZIMKitConversation(with: $0) })
            self.conversations.append(contentsOf: newConversations)
            self.conversations = self.conversations.sorted { $0.orderKey > $1.orderKey }
            
            callback?(error)
            
            if isCallbackListChanged == false { return }
            
            for delegate in self.delegates.allObjects {
                delegate.onConversationListChanged?(self.conversations)
            }
        })
    }
    
    // MARK: - Message
    func getMessageList(with conversationID: String,
                        type: ZIMConversationType,
                        callback: GetMessageListCallback? = nil) {
        let messages = messageList.getMessages(conversationID, type: type)
        if messages.count > 0 {
            let error = ZIMError()
            error.code = .success
            callback?(messages, error)
        } else {
            loadMoreMessage(with: conversationID, type: type, isCallbackListChanged: false) { error in
                let messages = self.messageList.getMessages(conversationID, type: type)
                callback?(messages, error)
            }
        }
    }
    
    func loadMoreMessage(with conversationID: String,
                         type: ZIMConversationType,
                         isCallbackListChanged: Bool = true,
                         callback: LoadMoreMessageCallback? = nil) {
        let messages = self.messageList.getMessages(conversationID, type: type)
        let config = ZIMMessageQueryConfig()
        config.count = 30
        config.nextMessage = messages.first?.zim
        config.reverse = true
        
        zim?.queryHistoryMessage(by: conversationID, conversationType: type, config: config, callback: { _, _, zimMessages, error in
            let kitMessages = zimMessages.compactMap({ ZIMKitMessage(with: $0) })
            self.messageList.addMessage(kitMessages, isNewMessage: false)
            
            if isCallbackListChanged == false { return }
            for delegate in self.delegates.allObjects {
                delegate.onHistoryMessageLoaded?(conversationID, type: type, messages: kitMessages)
            }
        })
    }
    
    func sendTextMessage(_ text: String,
                         to conversationID: String,
                         type: ZIMConversationType,
                         callback: MessageSentCallback? = nil) {
        let message = ZIMTextMessage(message: text)
        for delegate in delegates.allObjects {
            delegate.onPreMessageSending?(message)
        }
        let config = ZIMMessageSendConfig()
        let notification = ZIMMessageSendNotification()
        notification.onMessageAttached = { message in
            let message = ZIMKitMessage(with: message)
            self.messageList.addMessage([message])
            for delegate in self.delegates.allObjects {
                delegate.onMessageReceived?(conversationID, type: type, messages: [message])
            }
        }
        zim?.sendMessage(message, toConversationID: conversationID, conversationType: type, config: config, notification: notification, callback: { message, error in
            let message = self.messageList.getMessage(message)
            for delegate in self.delegates.allObjects {
                delegate.onMessageSentStatusChanged?(message)
            }
            callback?(message, error)
        })
    }
    
    func sendImageMessage(_ imagePath: String,
                          to conversationID: String,
                          type: ZIMConversationType,
                          callback: MessageSentCallback? = nil) {
        let imageMessage = ZIMImageMessage(fileLocalPath: imagePath)
        sendMediaMessage(imageMessage,
                         to: conversationID,
                         type: type,
                         callback: callback)
    }
    
    func sendAudioMessage(_ audioPath: String,
                          duration: UInt32,
                          to conversationID: String,
                          type: ZIMConversationType,
                          callback: MessageSentCallback? = nil) {
        let audioMessage = ZIMAudioMessage(fileLocalPath: audioPath, audioDuration: duration)
        sendMediaMessage(audioMessage, to: conversationID, type: type, callback: callback)
    }
    
    func sendVideoMessage(_ videoPath: String,
                          duration: UInt32,
                          to conversationID: String,
                          type: ZIMConversationType,
                          callback: MessageSentCallback? = nil) {
        let videoMessage = ZIMVideoMessage(fileLocalPath: videoPath, videoDuration: duration)
        
        sendMediaMessage(videoMessage, to: conversationID, type: type, callback: callback)
    }
    
    func sendFileMessage(_ filePath: String,
                         to conversationID: String,
                         type: ZIMConversationType,
                         callback: MessageSentCallback? = nil) {
        let fileMessage = ZIMFileMessage(fileLocalPath: filePath)
        sendMediaMessage(fileMessage, to: conversationID, type: type, callback: callback)
    }
    
    private func sendMediaMessage(_ message: ZIMMediaMessage,
                                  to conversationID: String,
                                  type: ZIMConversationType,
                                  callback: MessageSentCallback? = nil) {
        let config = ZIMMessageSendConfig()
        let notification = ZIMMediaMessageSendNotification()
        notification.onMessageAttached = { message in
            let message = ZIMKitMessage(with: message)
            self.messageList.addMessage([message])
            for delegate in self.delegates.allObjects {
                delegate.onMessageReceived?(conversationID, type: type, messages: [message])
            }
        }
        notification.onMediaUploadingProgress = { message, currentSize, totalSize in
            let message = self.messageList.getMessage(message)
            message.updateUploadProgress(currentSize: currentSize, totalSize: totalSize)
            for delegate in self.delegates.allObjects {
                delegate.onMediaMessageUploadingProgressUpdated?(message)
            }
        }
        zim?.sendMediaMessage(message,
                              toConversationID: conversationID,
                              conversationType: type,
                              config: config,
                              notification: notification,
                              callback: { message, error in
            let message = self.messageList.getMessage(message)
            for delegate in self.delegates.allObjects {
                delegate.onMessageSentStatusChanged?(message)
            }
            callback?(message, error)
        })
    }
    
    func downloadMediaFile(with message: ZIMKitMessage,
                           callback: DownloadMediaFileCallback? = nil) {
        guard let zimMessage = message.zim as? ZIMMediaMessage else {
            let error = ZIMError()
            error.code = .failed
            callback?(error)
            return
        }
        zim?.downloadMediaFile(with: zimMessage, fileType: .originalFile, progress: { _, currentSize, totalSize in
            message.updateDownloadProgress(currentSize: currentSize, totalSize: totalSize)
            for delegate in self.delegates.allObjects {
                delegate.onMediaMessageDownloadingProgressUpdated?(message)
            }
        }, callback: { message, error in
            callback?(error)
        })
    }
    
    func deleteMessage(_ messages: [ZIMKitMessage],
                       callback: DeleteMessageCallback? = nil) {
        
        if messages.count == 0 {
            let error = ZIMError()
            error.code = .failed
            callback?(error)
            return
        }
        
        let zimMessages = messages.compactMap({ $0.zim })
        let config = ZIMMessageDeleteConfig()
        let type = messages.first!.info.conversationType
        let conversationID = messages.first!.info.conversationID
        
        self.messageList.deleteMessage(messages)
        for delete in delegates.allObjects {
            delete.onMessageDeleted?(conversationID, type: type, messages: messages)
        }
        
        zim?.deleteMessages(zimMessages, conversationID: conversationID, conversationType: type, config: config, callback: { _, _, error in
            callback?(error)
        })
    }
}
