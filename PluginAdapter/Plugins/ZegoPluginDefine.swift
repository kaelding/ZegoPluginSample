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

// userIDs & attributes & errorKeys 顺序一一对应
public typealias SetUsersInRoomAttributesCallback = (_ errorCode: UInt,
                                                     _ errorMessage: String,
                                                     _ errorUserList: [String],
                                                     _ userIDs: [String],
                                                     _ attributes: [[String: String]],
                                                     _ errorKeys: [[String]]) -> ()

// userIDs & attributes 顺序一一对应
public typealias QueryUsersInRoomAttributesCallback = (_ errorCode: UInt,
                                                       _ errorMessage: String,
                                                       _ nextFlag: String,
                                                       _ userIDs: [String],
                                                       _ attributes: [[String: String]]) -> ()

public typealias RoomPropertyOperationCallback = (_ errorCode: UInt,
                                                  _ errorMessage: String,
                                                  _ errorKeys: [String]) -> ()

public typealias EndRoomBatchOperationCallback = (_ errorCode: UInt, _ errorMessage: String) -> ()


public typealias QueryRoomPropertyCallback = (_ errorCode: UInt,
                                              _ errorMessage: String,
                                              _ properties: [String: String]) -> ()

public enum ZegoPluginType {
    case signaling
    case callkit
    case beauty
    case whiteboard
}
