//
//  ZIMKitCore+User.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/9.
//

import Foundation
import ZIM

extension ZIMKitCore {
    func connectUser(userInfo: UserInfo, callback: ConnectUserCallback? = nil) {
        assert(zim != nil, "Must create ZIM first!!!")
        let zimUserInfo = ZIMUserInfo()
        zimUserInfo.userID = userInfo.id
        zimUserInfo.userName = userInfo.name
        zim?.login(with: zimUserInfo) { [weak self] error in
            if error.code == .success {
                self?.userInfo = userInfo
            }
            if let userAvatarUrl = userInfo.avatarUrl {
                self?.updateUserAvatarUrl(userAvatarUrl, callback: nil)
            }
            callback?(error)
        }
    }
    
    func disconnectUser() {
        zim?.logout()
        conversations.removeAll()
        messageList.clear()
    }
    
    func queryUserInfo(by userID: String,
                       isQueryFromServer: Bool,
                       callback: QueryUserCallback? = nil) {
        let config = ZIMUsersInfoQueryConfig()
        config.isQueryFromServer = isQueryFromServer
        zim?.queryUsersInfo(by: [userID], config: config, callback: { fullInfos, errorUserInfos, error in
            var userInfo: UserInfo?
            if let fullUserInfo = fullInfos.first {
                userInfo = UserInfo(fullUserInfo)
            }
            let errorUserInfo = errorUserInfos.first
            callback?(userInfo, errorUserInfo, error)
        })
    }
    
    func updateUserAvatarUrl(_ avatarUrl: String,
                             callback: UserAvatarUrlUpdateCallback? = nil) {
        zim?.updateUserAvatarUrl(avatarUrl, callback: { url, error in
            self.userInfo?.avatarUrl = url
            callback?(url, error)
        })
    }
}
