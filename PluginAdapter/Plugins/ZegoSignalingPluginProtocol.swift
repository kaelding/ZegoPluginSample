//
//  ZegoSignalingPluginProtocol.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation

public protocol ZegoSignalingPluginProtocol: ZegoPluginProtocol {
    
    func initWith(appID: UInt32, appSign: String)
    
    func connectUser(userID: String, userName: String, callback: LoginCallback?)
    
    func disconnectUser()
    
    // MARK: - Invitation
    // 将type参数去掉, 由业务方自行放入data中, plugin不需要关心invitation的type
    func sendInvitation(with invitees: [String],
                        timeout: UInt32,
                        data: String?,
                        callback: InvitationCallback?)
    
    // 加一个参数 invitationID
    func cancelInvitation(with invitees: [String],
                          invitationID: String,
                          data: String?,
                          callback: CancelInvitationCallback?)
    
    // 参数inviterID改为invitationID
    func refuseInvitation(with invitationID: String, data: String?, callback: ResponseInvitationCallback?)
    
    // 参数inviterID改为invitationID
    func acceptInvitation(with invitationID: String, data: String?, callback: ResponseInvitationCallback?)
    
    // MARK: - Room
    func joinRoom(with roomID: String, roomName: String?, callBack: RoomCallback?)
    
    // 离开房间加一个房间id参数
    func leaveRoom(by roomID: String, callBack: RoomCallback?)
    
    func setUsersInRoomAttributes(with attributes: [String: String],
                                  userIDs: [String],
                                  roomID: String,
                                  callback: SetUsersInRoomAttributesCallback?)
    
    // 增加一个roomID的参数
    func queryUsersInRoomAttributes(by roomID: String,
                                    count: UInt32,
                                    nextFlag: String,
                                    callback: QueryUsersInRoomAttributesCallback?)
    
    // 增加一个roomID的参数
    func updateRoomProperty(_ attributes: [String: String],
                            roomID: String,
                            isForce: Bool,
                            isDeleteAfterOwnerLeft: Bool,
                            isUpdateOwner: Bool,
                            callback: RoomPropertyOperationCallback?)
    
    // 增加一个roomID的参数
    func deleteRoomProperties(by keys: [String],
                              roomID: String,
                              isForce: Bool,
                              callback: RoomPropertyOperationCallback?)
    
    // 增加一个roomID的参数
    func beginRoomPropertiesBatchOperation(with roomID: String,
                                           isDeleteAfterOwnerLeft: Bool,
                                           isForce: Bool,
                                           isUpdateOwner: Bool)
    
    // 增加一个roomID的参数
    func endRoomPropertiesBatchOperation(with roomID: String,
                                         callback: EndRoomBatchOperationCallback?)
    
    // 增加一个roomID的参数
    func queryRoomProperties(by roomID: String, callback: QueryRoomPropertyCallback?)
    
    // MARK: - Register Event
    func registerPluginEventHandler(_ delegate: ZegoSignalingPluginEventHandler)
}


@objc public protocol ZegoSignalingPluginEventHandler: AnyObject {
    func onConnectionStateChanged(_ state: UInt)
    
    // MARK: - Invitation
    func onCallInvitationReceived(_ callID: String,
                                  inviterID: String,
                                  data: String)
    
    func onCallInvitationCancelled(_ callID: String,
                                  inviterID: String,
                                  data: String)
    
    func onCallInvitationAccepted(_ callID: String,
                                  inviteeID: String,
                                  data: String)
    
    func onCallInvitationRejected(_ callID: String,
                                  inviteeID: String,
                                  data: String)
    
    // 去掉inviter 只通过callID来判断
    func onCallInvitationTimeout(_ callID: String)
    
    func onCallInviteesAnsweredTimeout(_ callID: String, invitees: [String])
    
    // MARK: - Room
    // userIDs与attributes的顺序一致
    // 增加roomID回调参数
    func onUsersInRoomAttributesUpdated(_ userIDs: [String],
                                        attributes: [[String: String]],
                                        editor: String,
                                        roomID: String)
    
    // 增加roomID回调参数
    // properties和actions数组的顺序一致, action: 0 - set, 1 - delete
    func onRoomPropertiesUpdated(_ properties: [[String: String]], actions: [UInt], roomID: String)
    
    func onRoomMemberLeft(_ userIDList: [String], roomID: String)
    
    func onRoomMemberJoined(_ userIDList: [String], roomID: String)
}
