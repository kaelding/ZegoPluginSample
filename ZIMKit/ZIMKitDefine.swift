//
//  ZIMKitDefine.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/8.
//

import Foundation
import ZIM

public struct ZIMKitError {
    public let code: UInt
    public let message: String
}

public struct ZIMKitErrorUserInfo {
    public let userID: String
    public let reason: UInt32
}


/// Callback for the results that whether the connection is successful.
public typealias ConnectUserCallback = (_ error: ZIMKitError) -> Void

/// Callback for the updates on user avatar changes.
public typealias UserAvatarUrlUpdateCallback = (_ url: String, _ error: ZIMKitError) -> Void

/// Callback for the results that whether the group chat is created successfully.
/// - Parameters:
///     - groupInfo: group chat info.
///     - errorUserList: user error list, indicating that a user failed to join the group chat for some reason (e.g., the user does not exist), if the list is empty, indicating that all users have joined the group chat.
///     - error: error information, which indicates whether the current method is called successfully.
public typealias CreateGroupCallback = (_ groupInfoL: GroupInfo,
                                        _ errorUserList: [ZIMKitErrorUserInfo],
                                        _ error: ZIMKitError) -> Void

/// Callback for the results that whether the group chat is joined successfully.
/// - Parameters:
///     - groupInfo: group chat info.
///     - error: error information.
public typealias JoinGroupCallback = (_ groupInfo: GroupInfo, _ error: ZIMKitError) -> Void
