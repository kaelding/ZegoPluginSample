//
//  GroupMember.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/31.
//

import Foundation
import ZIM

public enum GroupMemberRole {
    case owner
    case member
}

public struct GroupMember {
    /// UserID: 1 to 32 characters, can only contain digits, letters, and the following special characters: '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
    public var id: String

    /// User name: 1 - 64 characters.
    public var name: String

    /// User avatar URL.
    public var avatarUrl: String?
    
    public var nickName: String
    
    public var role: GroupMemberRole
    
    init(with member: ZIMGroupMemberInfo) {
        id = member.userID
        name = member.userName
        nickName = member.memberNickname
        role = member.memberRole == 1 ? .owner : .member
        avatarUrl = member.memberAvatarUrl
    }
}
