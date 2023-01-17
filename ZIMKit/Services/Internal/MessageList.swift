//
//  MessageList.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/5.
//

import Foundation
import ZIM

class MessageList {
    private class MessageMap {
        var map: [String: [ZIMKitMessage]] = [:]
    }
    
    private var list: [ZIMConversationType: MessageMap] = [:]
    
    func addMessage(_ newMessages: [ZIMKitMessage], isNewMessage: Bool = true) {
        
        if newMessages.count == 0 { return }
        
        let conversationID = newMessages.first!.info.conversationID
        let type = newMessages.first!.info.conversationType
        
        // get or create messageMap
        var messageMap: MessageMap?
        messageMap = getMessageMap(type)
        if messageMap == nil {
            messageMap = MessageMap()
            list[type] = messageMap
        }
        
        // update message
        var messages = [ZIMKitMessage]()
        if let oldMessages = messageMap?.map[conversationID] {
            messages.append(contentsOf: oldMessages)
        }
        if isNewMessage {
            messages.append(contentsOf: newMessages)
        } else {
            messages.insert(contentsOf: newMessages, at: 0)
        }
        messageMap?.map[conversationID] = messages
    }
    
    func deleteMessage(_ messages: [ZIMKitMessage]) {
        if messages.count == 0 { return }
        let conversationID = messages.first!.info.conversationID
        let type = messages.first!.info.conversationType
        let allMessages = getMessages(conversationID, type: type)
        let newMessages = allMessages.filter({ messages.compactMap({ $0.info.messageID }).contains($0.info.messageID) == false })
        let messageMap = getMessageMap(messages.first!.info.conversationType)
        messageMap?.map[conversationID] = newMessages
    }
    
    func clear() {
        list.removeAll()
    }
    
    func getMessage(_ zimMessage: ZIMMessage) -> ZIMKitMessage {
        let messages = getMessages(zimMessage.conversationID, type: zimMessage.conversationType)
        let kitMessage = messages.first(where: { $0.info.messageID == zimMessage.messageID })
        return kitMessage ?? ZIMKitMessage(with: zimMessage)
    }
    
    func getMessages(_ conversationID: String, type: ZIMConversationType) -> [ZIMKitMessage] {
        return getMessageMap(type)?.map[conversationID] ?? []
    }
    
    private func getMessageMap(_ type: ZIMConversationType) -> MessageMap? {
        return list[type]
    }
}
