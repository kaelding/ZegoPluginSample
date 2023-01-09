//
//  ZegoSignalingPlugin.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/7.
//

import Foundation
import ZegoPluginAdapter
import ZIM

public class ZegoSignalingPlugin: ZegoSignalingPluginProtocol {

    public static let shared = ZegoSignalingPlugin()
    
    public init() {
        
    }
    
    let service = ZegoSignalingPluginService.shared
    
    public var pluginType: ZegoPluginType {
        .signaling
    }
    
    public var version: String {
        "1.0.0"
    }
    
    public func initWith(appID: UInt32, appSign: String?) {
        service.initWith(appID: appID, appSign: appSign)
    }
    
    public func connectUser(userID: String,
                            userName: String,
                            token: String?,
                            callback: ConnectUserCallback?) {
        service.connectUser(userID: userID,
                            userName: userName,
                            token: token,
                            callback: callback)
    }
    
    public func disconnectUser() {
        service.disconnectUser()
    }
    
    public func renewToken(_ token: String, callback: RenewTokenCallback?) {
        service.renewToken(token, callback: callback)
    }
    
    // MARK: - Invitation
    public func sendInvitation(with invitees: [String],
                               timeout: UInt32,
                               data: String?,
                               notificationConfig: ZegoSignalingPluginNotificationConfig?,
                               callback: InvitationCallback?) {
        service.sendInvitation(with: invitees,
                               timeout: timeout,
                               data: data,
                               notificationConfig: notificationConfig,
                               callback: callback)
    }
    
    public func cancelInvitation(with invitees: [String], invitationID: String, data: String?, callback: CancelInvitationCallback?) {
        service.cancelInvitation(with: invitees, invitationID: invitationID, data: data, callback: callback)
    }
    
    public func refuseInvitation(with invitationID: String,
                                 data: String?,
                                 callback: ResponseInvitationCallback?) {
        service.refuseInvitation(with: invitationID, data: data, callback: callback)
    }
    
    public func acceptInvitation(with invitationID: String,
                                 data: String?,
                                 callback: ResponseInvitationCallback?) {
        service.acceptInvitation(with: invitationID, data: data, callback: callback)
    }
    
    public func enableNotifyWhenAppRunningInBackgroundOrQuit(_ enable: Bool,
                                                             isIOSDevelopmentEnvironment: Bool) {
        service.enableNotifyWhenAppRunningInBackgroundOrQuit(enable, isIOSDevelopmentEnvironment: isIOSDevelopmentEnvironment)
    }
    
    public func setRemoteNotificationsDeviceToken(_ deviceToken: Data) {
        service.setRemoteNotificationsDeviceToken(deviceToken)
    }
    
    // MARK: - Room
    public func joinRoom(with roomID: String, roomName: String?, callBack: RoomCallback?) {
        service.joinRoom(with: roomID, roomName: roomName, callBack: callBack)
    }
    
    public func leaveRoom(by roomID: String, callBack: RoomCallback?) {
        service.leaveRoom(by: roomID, callBack: callBack)
    }
    
    public func setUsersInRoomAttributes(with attributes: [String: String],
                                         userIDs: [String],
                                         roomID: String,
                                         callback: SetUsersInRoomAttributesCallback?) {
        service.setUsersInRoomAttributes(with: attributes,
                                         userIDs: userIDs,
                                         roomID: roomID,
                                         callback: callback)
    }
    
    public func queryUsersInRoomAttributes(by roomID: String,
                                           count: UInt32,
                                           nextFlag: String,
                                           callback: QueryUsersInRoomAttributesCallback?) {
        service.queryUsersInRoomAttributes(by: roomID,
                                           count: count,
                                           nextFlag: nextFlag,
                                           callback: callback)
    }
    
    public func updateRoomProperty(_ attributes: [String: String],
                                   roomID: String,
                                   isForce: Bool,
                                   isDeleteAfterOwnerLeft: Bool,
                                   isUpdateOwner: Bool,
                                   callback: RoomPropertyOperationCallback?) {
        service.updateRoomProperty(attributes,
                                   roomID: roomID,
                                   isForce: isForce,
                                   isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
                                   isUpdateOwner: isUpdateOwner,
                                   callback: callback)
    }
    
    public func deleteRoomProperties(by keys: [String],
                                     roomID: String,
                                     isForce: Bool,
                                     callback: RoomPropertyOperationCallback?) {
        service.deleteRoomProperties(by: keys,
                                     roomID: roomID,
                                     isForce: isForce,
                                     callback: callback)
    }
    
    public func beginRoomPropertiesBatchOperation(with roomID: String,
                                                  isDeleteAfterOwnerLeft: Bool,
                                                  isForce: Bool,
                                                  isUpdateOwner: Bool) {
        service.beginRoomPropertiesBatchOperation(with: roomID,
                                                  isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft,
                                                  isForce: isForce,
                                                  isUpdateOwner: isUpdateOwner)
    }
    
    public func endRoomPropertiesBatchOperation(with roomID: String,
                                                callback: EndRoomBatchOperationCallback?) {
        service.endRoomPropertiesBatchOperation(with: roomID, callback: callback)
    }
    
    public func queryRoomProperties(by roomID: String, callback: QueryRoomPropertyCallback?) {
        service.queryRoomProperties(by: roomID, callback: callback)
    }
    
    public func sendRoomMessage(_ text: String, roomID: String, callback: SendRoomMessageCallback?) {
        service.sendRoomMessage(text, roomID: roomID, callback: callback)
    }
    
    // MARK: - Register Event
    public func registerPluginEventHandler(_ handler: ZegoSignalingPluginEventHandler) {
        service.registerPluginEventHandler(handler)
    }
    
    // register ZIM EventHandler
    public func registerZIMEventHandler(_ handler: ZIMEventHandler) {
        service.registerZIMEventHandler(handler)
    }
}
