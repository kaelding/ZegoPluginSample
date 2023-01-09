//
//  ZIMKitDelegate.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/28.
//

import Foundation
import ZIM

@objc public protocol ZIMKitDelegate: AnyObject {
    /// Callback for updates on the connection status changes.
    /// The event callback when the connection state changes.
    /// - Parameters:
    ///   - state: the current connection status.
    ///   - event: the event happened. The event that causes the connection status to change.
    @objc optional
    func onConnectionStateChange(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent)

    // MARK: - Conversation
    /// Total number of unread messages.
    /// - Parameter totalCount: Total number of unread messages.
    @objc optional
    func onTotalUnreadMessageCountChange(_ totalCount: UInt32)
    
    @objc optional
    func onConversationListChanged(_ conversations: [ZIMKitConversation])
    
    // MARK: - Message
    @objc optional
    func onPreMessageSending(_ message: ZIMMessage)
    
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
