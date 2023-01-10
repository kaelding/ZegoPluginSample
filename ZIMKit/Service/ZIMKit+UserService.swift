//
//  ZIMKit+UserService.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/29.
//

import Foundation

extension ZIMKit {
    // 不支持静态属性的平台可以改为getCurrentUser方法
    public static var currentUser: UserInfo? {
        ZIMKitCore.shared.userInfo
    }
    
    public static func connectUser(userInfo: UserInfo, callback: ConnectUserCallback? = nil) {
        ZIMKitCore.shared.connectUser(userInfo: userInfo, callback: callback)
    }
    
    public static func disconnectUser() {
        ZIMKitCore.shared.disconnectUser()
    }
    
    public static func queryUserInfo(by userID: String,
                                 isQueryFromServer: Bool = true,
                                 callback: QueryUserCallback? = nil) {
        ZIMKitCore.shared.queryUserInfo(by: userID,
                                        isQueryFromServer: isQueryFromServer,
                                        callback: callback)
    }
    
    public static func updateUserAvatarUrl(_ avatarUrl: String,
                                           callback: UserAvatarUrlUpdateCallback? = nil) {
        ZIMKitCore.shared.updateUserAvatarUrl(avatarUrl, callback: callback)
    }
}
