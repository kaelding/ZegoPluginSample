//
//  ZIMKitCore+Message.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/9.
//

import Foundation
import ZIM

extension ZIMKitCore {
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
        
        if !FileManager.default.fileExists(atPath: imagePath) {
            assert(false, "Path doesn't exist.")
            return
        }
        
        let filePrefix = ZIMKit.imagePath(conversationID, type) + generateFileName()
        let filePath = filePrefix + ".\(URL(fileURLWithPath: imagePath).pathExtension)"
        try? FileManager.default.copyItem(atPath: imagePath, toPath: filePath)
        
        let imageMessage = ZIMImageMessage(fileLocalPath: filePath)
        sendMediaMessage(imageMessage,
                         to: conversationID,
                         type: type,
                         callback: callback)
    }
    
    func sendAudioMessage(_ audioPath: String,
                          to conversationID: String,
                          type: ZIMConversationType,
                          callback: MessageSentCallback? = nil) {
        
        if !FileManager.default.fileExists(atPath: audioPath) {
            assert(false, "Path doesn't exist.")
            return
        }
        
        let filePrefix = ZIMKit.audioPath(conversationID, type) + generateFileName()
        let filePath = filePrefix + ".\(URL(fileURLWithPath: audioPath).pathExtension)"
        try? FileManager.default.copyItem(atPath: audioPath, toPath: filePath)
        
        let duration = UInt32(AVTool.getDurationOfMediaFile(audioPath))
                
        let audioMessage = ZIMAudioMessage(fileLocalPath: filePath, audioDuration: duration)
        sendMediaMessage(audioMessage, to: conversationID, type: type, callback: callback)
    }
    
    func sendVideoMessage(_ videoPath: String,
                          to conversationID: String,
                          type: ZIMConversationType,
                          callback: MessageSentCallback? = nil) {
        if !FileManager.default.fileExists(atPath: videoPath) {
            assert(false, "Path doesn't exist.")
            return
        }
        
        let filePrefix = ZIMKit.videoPath(conversationID, type) + generateFileName()
        let filePath = filePrefix + ".\(URL(fileURLWithPath: videoPath).pathExtension)"
        try? FileManager.default.copyItem(atPath: videoPath, toPath: filePath)
        
        let duration = UInt32(AVTool.getDurationOfMediaFile(videoPath))
                
        let videoMessage = ZIMVideoMessage(fileLocalPath: filePath, videoDuration: duration)
        sendMediaMessage(videoMessage, to: conversationID, type: type, callback: callback)
    }
    
    func sendFileMessage(_ filePath: String,
                         to conversationID: String,
                         type: ZIMConversationType,
                         callback: MessageSentCallback? = nil) {
        
        if !FileManager.default.fileExists(atPath: filePath) {
            assert(false, "Path doesn't exist.")
            return
        }
        
        let filePrefix = ZIMKit.filePath(conversationID, type) + generateFileName()
        let newFilePath = filePrefix + ".\(URL(fileURLWithPath: filePath).pathExtension)"
        try? FileManager.default.copyItem(atPath: filePath, toPath: newFilePath)
        
        let fileMessage = ZIMFileMessage(fileLocalPath: newFilePath)
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
            
            if error.code != .success { return }
            if let message = message.zim as? ZIMImageMessage {
                try? FileManager.default.removeItem(atPath: message.fileLocalPath)
            }
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
            
            if error.code != .success { return }
            for message in messages {
                if let msg = message.zim as? ZIMImageMessage {
                    // remove image from cache.
                    // TODO: ImageCache.removeCache
                    
                    // remove image from local.
                    if FileManager.default.fileExists(atPath: msg.fileLocalPath) {
                        try? FileManager.default.removeItem(atPath: msg.fileLocalPath)
                    }
                } else if let msg = message.zim as? ZIMMediaMessage {
                    if FileManager.default.fileExists(atPath: msg.fileLocalPath) {
                        try? FileManager.default.removeItem(atPath: msg.fileLocalPath)
                    }
                }
            }
        })
    }
    
    private func generateFileName() -> String {
        return String(format: "%d%0.0f", UInt32.random(in: 1000...9999), Date().timeIntervalSince1970)
    }
}
