//
//  ZIMKit.swift
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation

public class ZIMKit: NSObject {
    
    /// Initialize the ZIMKit.
    /// You will need to initialize the ZIMKit SDK before calling methods.
    /// - Parameters:
    ///   - appID: appID. To get this, go to ZEGOCLOUD Admin Console (https://console.zegocloud.com/).
    ///   - appSign: appSign. To get this, go to ZEGOCLOUD Admin Console (https://console.zegocloud.com/).
    public static func initWith(appID: UInt32, appSign: String) {
        ZIMKitService.shared.initWith(appID: appID, appSign: appSign)
    }
    
    /// Connects user to the ZIMKit server.
    ///  This method can only be used after calling the [initWith:] method and before you calling any other methods.
    /// - Parameters:
    ///   - userInfo: user info
    ///   - callback: callback for the results that whether the connection is successful.
    public static func connectUser(userInfo: UserInfo, callback: ConnectUserCallback?) {
        ZIMKitService.shared.connectUser(userInfo: userInfo, callback: callback)
    }
    
    /// Disconnects current user from ZIMKit server.
    public static func disconnectUser() {
        ZIMKitService.shared.disconnectUser()
    }
    
    /// Update the user avatar
    /// After a successful connection, you can change the user avatar as needed.
    /// - Parameters:
    ///   - avatarUrl: avatar URL.
    ///   - callback: callback for the results that whether the user avatar is updated successfully.
    public static func updateUserAvatarUrl(_ avatarUrl: String, callback: UserAvatarUrlUpdateCallback?) {
        ZIMKitService.shared.updateUserAvatarUrl(avatarUrl, callback: callback)
    }
    
    /// Create a group chat
    /// You can choose multiple users besides yourself to start a group chat.
    /// - Parameters:
    ///   - groupName: group name.
    ///   - userIDs: user ID list.
    ///   - callback: callback for the results that whether the group chat is created successfully.
    public static func createGroup(with groupName: String, userIDs: [String], callback: CreateGroupCallback?) {
        ZIMKitService.shared.createGroup(with: groupName, userIDs: userIDs, callback: callback)
    }
    
    /// Join the group chat
    /// - Parameters:
    ///   - groupID: group ID
    ///   - callback: callback for the results that whether the group chat is joined successfully.
    public static func joinGroup(by groupID: String, callback: JoinGroupCallback?) {
        ZIMKitService.shared.joinGroup(by: groupID, callback: callback)
    }
}
