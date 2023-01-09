//
//  ZegoPluginDefine.swift
//  ZegoPluginAdapter
//
//  Created by Kael Ding on 2022/12/7.
//

import Foundation

public typealias ConnectUserCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()

public typealias RenewTokenCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()

public typealias InvitationCallback = (_ errorCode: UInt,
                                       _ errorMessage: String,
                                       _ invitationID: String,
                                       _ errorInvitees: [String]) -> ()

public typealias CancelInvitationCallback = (_ errorCode: UInt,
                                             _ errorMessage: String,
                                             _ errorInvitees: [String]) -> ()

public typealias ResponseInvitationCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()

public typealias RoomCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()

// attributesMap, userID: attributes
// errorKeysMap, userID: errorKeys
public typealias SetUsersInRoomAttributesCallback = (_ errorCode: UInt,
                                                     _ errorMessage: String,
                                                     _ errorUserList: [String],
                                                     _ attributesMap: [String: [String: String]],
                                                     _ errorKeysMap: [String: [String]]) -> ()

// attributesMap, userID: attributes
public typealias QueryUsersInRoomAttributesCallback = (_ errorCode: UInt,
                                                       _ errorMessage: String,
                                                       _ nextFlag: String,
                                                       _ attributesMap: [String: [String: String]]) -> ()

public typealias RoomPropertyOperationCallback = (_ errorCode: UInt,
                                                  _ errorMessage: String,
                                                  _ errorKeys: [String]) -> ()

public typealias EndRoomBatchOperationCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()


public typealias QueryRoomPropertyCallback = (_ errorCode: UInt,
                                              _ errorMessage: String,
                                              _ properties: [String: String]) -> ()

public typealias SendRoomMessageCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()

public enum ZegoPluginType {
    case signaling
    case callkit
    case beauty
    case whiteboard
}

@objc public enum ZegoSignalingPluginConnectionState: UInt {
    case disconnected
    case connecting
    case connected
    case reconnecting
}

public class ZegoSignalingInRoomTextMessage: NSObject {
    public var messageID: Int64 = 0
    public var timestamp: UInt64 = 0
    public var orderKey: Int64 = 0
    public var senderUserID: String = ""
    public var text: String = ""
    
    public init(messageID: Int64,
                timestamp: UInt64,
                orderKey: Int64,
                senderUserID: String,
                text: String) {
        self.messageID = messageID
        self.timestamp = timestamp
        self.orderKey = orderKey
        self.senderUserID = senderUserID
        self.text = text
    }
}

public class ZegoSignalingPluginNotificationConfig: NSObject {
    public let resourceID: String
    public let title: String
    public let message: String
    
    init(resourceID: String, title: String, message: String) {
        self.resourceID = resourceID
        self.title = title
        self.message = message
    }
}
