//
//  ZIMKit+UserService.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/29.
//

import Foundation

extension ZIMKit {
    
    public static var currentUser: UserInfo? {
        ZIMKitCore.shared.userInfo
    }
    
    /// Connects user to the ZIMKit server.
    ///  This method can only be used after calling the [initWith:] method and before you calling any other methods.
    /// - Parameters:
    ///   - userInfo: user info
    ///   - callback: callback for the results that whether the connection is successful.
    public static func connectUser(userInfo: UserInfo, callback: ConnectUserCallback? = nil) {
        ZIMKitCore.shared.connectUser(userInfo: userInfo, callback: callback)
    }
    
    /// Disconnects current user from ZIMKit server.
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
    
    /// Update the user avatar
    /// After a successful connection, you can change the user avatar as needed.
    /// - Parameters:
    ///   - avatarUrl: avatar URL.
    ///   - callback: callback for the results that whether the user avatar is updated successfully.
    public static func updateUserAvatarUrl(_ avatarUrl: String,
                                           callback: UserAvatarUrlUpdateCallback? = nil) {
        ZIMKitCore.shared.updateUserAvatarUrl(avatarUrl, callback: callback)
    }
}
