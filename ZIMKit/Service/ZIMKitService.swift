//
//  ZIMKitService.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/8.
//

import Foundation
import ZIM
import ZegoSignalingPlugin

class ZIMKitService: NSObject, ZIMEventHandler {
    static let shared = ZIMKitService()
    
    var zim: ZIM? = nil
    
    fileprivate(set) var userInfo: UserInfo?
    
    func initWith(appID: UInt32, appSign: String) {
        ZegoSignalingPlugin.shared.initWith(appID: appID, appSign: appSign)
        zim = ZIM.shared()
    }
    
    func connectUser(userInfo: UserInfo, callback: ConnectUserCallback?) {
        assert(zim != nil, "Must create ZIM first!!!")
        self.userInfo = userInfo
        let zimUserInfo = ZIMUserInfo()
        zimUserInfo.userID = userInfo.id
        zimUserInfo.userName = userInfo.name
        zim?.login(with: zimUserInfo, token: "", callback: { error in
            if let userAvatarUrl = userInfo.avatarUrl {
                self.updateUserAvatarUrl(userAvatarUrl) { _, error in
                    if error.code == 0 {
                        print("Update user's avatar success.")
                    }
                }
            }
            callback?(ZIMKitError(code: error.code.rawValue, message: error.message))
        })
    }
    
    func disconnectUser() {
        zim?.logout()
    }
    
    func updateUserAvatarUrl(_ avatarUrl: String, callback: UserAvatarUrlUpdateCallback?) {
        zim?.updateUserAvatarUrl(avatarUrl, callback: { url, error in
            self.userInfo?.avatarUrl = url
            callback?(url, ZIMKitError(code: error.code.rawValue, message: error.message))
        })
    }
    
    func createGroup(with groupName: String, userIDs: [String], callback: CreateGroupCallback?) {
        let info = ZIMGroupInfo()
        info.groupName = groupName
        zim?.createGroup(with: info, userIDs: userIDs, callback: { fullInfo, _, errors, error in
            let info = GroupInfo(with: fullInfo)
            let error = ZIMKitError(code: error.code.rawValue, message: error.message)
            let errorUserList = errors.compactMap {
                ZIMKitErrorUserInfo(userID: $0.userID, reason: $0.reason)
            }
            callback?(info, errorUserList, error)
        })
    }
    
    func joinGroup(by groupID: String, callback: JoinGroupCallback?) {
        zim?.joinGroup(by: groupID, callback: { fullInfo, error in
            let info = GroupInfo(with: fullInfo)
            callback?(info, ZIMKitError(code: error.code.rawValue, message: error.message))
        })
    }
    
    // register ZIM EventHandler
    func registerZIMEventHandler(_ handler: ZIMEventHandler) {
        ZegoSignalingPlugin.shared.registerZIMEventHandler(handler)
    }
}
