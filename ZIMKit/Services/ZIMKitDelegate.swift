//
//  ZIMKitDelegate.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/28.
//

import Foundation
import ZIM

@objc public protocol ZIMKitDelegate: AnyObject {
    @objc optional
    func onConnectionStateChange(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent)

    @objc optional
    func onTotalUnreadMessageCountChange(_ totalCount: UInt32)
    
    @objc optional
    func onConversationListChanged(_ conversations: [ZIMKitConversation])
    
    // MARK: - Message
    @objc optional
    func onPreMessageSending(_ message: ZIMKitMessage) -> ZIMKitMessage?
    
    // 收到新消息或自己发送新消息会触发此回调
    @objc optional
    func onMessageReceived(_ conversationID: String,
                           type: ZIMConversationType,
                           messages: [ZIMKitMessage])
    
    // 调用loadMoreMessage会收到此回调
    @objc optional
    func onHistoryMessageLoaded(_ conversationID: String,
                                type: ZIMConversationType,
                                messages: [ZIMKitMessage])
    
    @objc optional
    func onMessageDeleted(_ conversationID: String,
                          type: ZIMConversationType,
                          messages: [ZIMKitMessage])
    
    @objc optional
    func onMessageSentStatusChanged(_ message: ZIMKitMessage)
    
    @objc optional
    func onMediaMessageUploadingProgressUpdated(_ message: ZIMKitMessage)
    
    @objc optional
    func onMediaMessageDownloadingProgressUpdated(_ message: ZIMKitMessage)
}
