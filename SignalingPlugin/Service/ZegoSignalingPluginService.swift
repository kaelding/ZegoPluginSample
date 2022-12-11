//
//  ZegoSignalingPluginService.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/7.
//

import Foundation
import ZIM
import ZegoPluginAdapter

class ZegoSignalingPluginService: NSObject {
    
    static let shared = ZegoSignalingPluginService()
    
    let pluginEventHandlers: NSHashTable<ZegoSignalingPluginEventHandler> = NSHashTable(options: .weakMemory)
    let zimEventHandlers: NSHashTable<ZIMEventHandler> = NSHashTable(options: .weakMemory)
    
    var zim: ZIM? = nil
    var userInfo: ZIMUserInfo? = nil
    
    func initWith(appID: UInt32, appSign: String) {
        if ZIM.shared() != nil {
            zim = ZIM.shared()
            return
        }
        let config = ZIMAppConfig()
        config.appID = appID
        config.appSign = appSign
        zim = ZIM.create(with: config)
        zim?.setEventHandler(self)
    }
    
    func connectUser(userID: String, userName: String, callback: LoginCallback?) {
        let user = ZIMUserInfo()
        user.userID = userID
        user.userName = userName
        userInfo = user
        zim?.login(with: user, callback: { error in
            callback?(error.code.rawValue, error.message)
        })
    }
    
    func disconnectUser() {
        zim?.logout()
    }
    
    // MARK: - Invitation
    func sendInvitation(with invitees: [String],
                               timeout: UInt32,
                               data: String?,
                               callback: InvitationCallback?) {
        
        let config = ZIMCallInviteConfig()
        config.timeout = timeout
        config.extendedData = data ?? ""
        zim?.callInvite(with: invitees, config: config, callback: { callID, info, error in
            let code = error.code.rawValue
            let message = error.message
            let errorInvitees = info.errorInvitees.compactMap({ $0.userID })
            callback?(code, message, callID, errorInvitees)
        })
    }
    
    func cancelInvitation(with invitees: [String], invitationID: String, data: String?, callback: CancelInvitationCallback?) {
        let config = ZIMCallCancelConfig()
        config.extendedData = data ?? ""
        zim?.callCancel(with: invitees, callID: invitationID, config: config, callback: { callID, errorInvitees, error in
            let code = error.code.rawValue
            let message = error.message
            callback?(code, message, errorInvitees)
        })
    }
    
    func refuseInvitation(with invitationID: String,
                                 data: String?,
                                 callback: ResponseInvitationCallback?) {
        let config = ZIMCallRejectConfig()
        config.extendedData = data ?? ""
        zim?.callReject(with: invitationID, config: config, callback: { callID, error in
            callback?(error.code.rawValue, error.message)
        })
    }
    
    func acceptInvitation(with invitationID: String,
                                 data: String?,
                                 callback: ResponseInvitationCallback?) {
        let config = ZIMCallAcceptConfig()
        config.extendedData = data ?? ""
        zim?.callAccept(with: invitationID, config: config, callback: { callID, error in
            callback?(error.code.rawValue, error.message)
        })
    }
    
    // MARK: - Room
    func joinRoom(with roomID: String, roomName: String?, callBack: RoomCallback?) {
        
        let roomInfo = ZIMRoomInfo()
        roomInfo.roomID = roomID
        roomInfo.roomName = roomName ?? ""
        let config = ZIMRoomAdvancedConfig()
        
        zim?.enterRoom(with: roomInfo, config: config, callback: { info, error in
            callBack?(error.code.rawValue, error.message)
        })
    }
    
    func leaveRoom(by roomID: String, callBack: RoomCallback?) {
        zim?.leaveRoom(by: roomID, callback: { roomID, error in
            callBack?(error.code.rawValue, error.message)
        })
    }
    
    func setUsersInRoomAttributes(with attributes: [String: String], userIDs: [String], roomID: String, callback: SetUsersInRoomAttributesCallback?) {
        let config = ZIMRoomMemberAttributesSetConfig()
        zim?.setRoomMembersAttributes(attributes, userIDs: userIDs, roomID: roomID, config: config, callback: { roomID, infos, errorUserList, error in
            let code = error.code.rawValue
            let message = error.message
            let attributeInfos: [[String: Any]] = infos.compactMap { info in
                ["userID": info.attributesInfo.userID,
                 "attributes": info.attributesInfo.attributes]
            }
            callback?(code, message, errorUserList, attributeInfos, roomID)
        })
    }
    
    func queryUsersInRoomAttributes(by roomID: String,
                                    count: UInt32,
                                    nextFlag: String,
                                    callback: QueryUsersInRoomAttributesCallback?) {
        let config = ZIMRoomMemberAttributesQueryConfig()
        config.nextFlag = nextFlag
        config.count = count
        zim?.queryRoomMemberAttributesList(by: roomID, config: config, callback: { roomID, infos, nextFlag, error in
            let code = error.code.rawValue
            let message = error.message
            let attributeInfos: [[String: Any]] = infos.compactMap { info in
                ["userID": info.userID,
                 "attributes": info.attributes]
            }
            callback?(code, message, nextFlag, attributeInfos, roomID)
        })
    }
    
    func updateRoomProperty(_ attributes: [String: String],
                            roomID: String,
                            isForce: Bool,
                            isDeleteAfterOwnerLeft: Bool,
                            isUpdateOwner: Bool,
                            callback: RoomPropertyOperationCallback?) {
        let config = ZIMRoomAttributesSetConfig()
        config.isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
        config.isForce = isForce
        config.isUpdateOwner = isUpdateOwner
        zim?.setRoomAttributes(attributes, roomID: roomID, config: config, callback: { roomID, errorKeys, error in
            callback?(error.code.rawValue, error.message, errorKeys)
        })
    }
    
    func deleteRoomProperties(by keys: [String],
                              roomID: String,
                              isForce: Bool,
                              callback: RoomPropertyOperationCallback?) {
        let config = ZIMRoomAttributesDeleteConfig()
        config.isForce = isForce
        zim?.deleteRoomAttributes(by: keys, roomID: roomID, config: config, callback: { roomID, errorKeys, error in
            callback?(error.code.rawValue, error.message, errorKeys)
        })
    }
    
    func beginRoomPropertiesBatchOperation(with roomID: String,
                                           isDeleteAfterOwnerLeft: Bool,
                                           isForce: Bool,
                                           isUpdateOwner: Bool) {
        let config = ZIMRoomAttributesBatchOperationConfig()
        config.isForce = isForce
        config.isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
        config.isUpdateOwner = isUpdateOwner
        zim?.beginRoomAttributesBatchOperation(with: roomID, config: config)
    }
    
    func endRoomPropertiesBatchOperation(with roomID: String, callback: EndRoomBatchOperationCallback?) {
        zim?.endRoomAttributesBatchOperation(with: roomID, callback: { roomID, error in
            callback?(error.code.rawValue, error.message)
        })
    }
    
    func queryRoomProperties(by roomID: String, callback: QueryRoomPropertyCallback?) {
        zim?.queryRoomAllAttributes(by: roomID, callback: { roomID, roomAttributes, error in
            callback?(error.code.rawValue, error.message, roomAttributes)
        })
    }
    
    // MARK: - Register Event
    func registerPluginEventHandler(_ handler: ZegoSignalingPluginEventHandler) {
        pluginEventHandlers.add(handler)
    }
    
    func registerZIMEventHandler(_ handler: ZIMEventHandler) {
        zimEventHandlers.add(handler)
    }
}