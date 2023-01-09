//
//  ZIMKitCore+EventHandler.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/3.
//

import Foundation
import ZIM

extension ZIMKitCore: ZIMEventHandler {
    
    // MARK: - User
    func zim(_ zim: ZIM, connectionStateChanged state: ZIMConnectionState, event: ZIMConnectionEvent, extendedData: [AnyHashable : Any]) {
        for delegate in delegates.allObjects {
            delegate.onConnectionStateChange?(state, event)
        }
    }
    
    // MARK: - Conversation
    func zim(_ zim: ZIM, conversationChanged conversationChangeInfoList: [ZIMConversationChangeInfo]) {
        for changeInfo in conversationChangeInfoList {
            if let index = conversations.firstIndex(where: { con in
                con.id == changeInfo.conversation.conversationID && con.type == changeInfo.conversation.type
            }) {
                conversations.remove(at: index)
            }
            conversations.append(ZIMKitConversation(with: changeInfo.conversation))
        }
        conversations = conversations.sorted { $0.orderKey > $1.orderKey }
        
        for delegate in delegates.allObjects {
            delegate.onConversationListChanged?(conversations)
        }
    }
    
    func zim(_ zim: ZIM, conversationTotalUnreadMessageCountUpdated totalUnreadMessageCount: UInt32) {
        for delegate in delegates.allObjects {
            delegate.onTotalUnreadMessageCountChange?(totalUnreadMessageCount)
        }
    }
    
    // MARK: - Group
    
    
    // MARK: - Message
    func zim(_ zim: ZIM, receivePeerMessage messageList: [ZIMMessage], fromUserID: String) {
        handleReceiveNewMessages(messageList)
    }
    
    func zim(_ zim: ZIM, receiveGroupMessage messageList: [ZIMMessage], fromGroupID: String) {
        handleReceiveNewMessages(messageList)
    }
    
    func zim(_ zim: ZIM, receiveRoomMessage messageList: [ZIMMessage], fromRoomID: String) {
        handleReceiveNewMessages(messageList)
    }
    
    private func handleReceiveNewMessages(_ zimMessageList: [ZIMMessage]) {
        
        if zimMessageList.count == 0 { return }
        
        let conversationID = zimMessageList.first!.conversationID
        let conversationType = zimMessageList.first!.conversationType
        
        let zimMessageList = zimMessageList.sorted { $0.timestamp < $1.timestamp }
        let kitMessages = zimMessageList.compactMap({ ZIMKitMessage(with: $0) })
        messageList.addMessage(kitMessages)
        
        for delegate in delegates.allObjects {
            delegate.onMessageReceived?(conversationID,
                                         type: conversationType,
                                         messages: kitMessages)
        }
    }
}
