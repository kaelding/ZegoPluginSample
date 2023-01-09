//
//  ZIMKit+GroupService.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/29.
//

import Foundation

extension ZIMKit {
    /// Create a group chat
    /// You can choose multiple users besides yourself to start a group chat.
    /// - Parameters:
    ///   - groupName: group name.
    ///   - groupID: group ID.
    ///   - userIDs: user ID list.
    ///   - callback: callback for the results that whether the group chat is created successfully.
    public static func createGroup(with groupName: String,
                                   groupID: String = "",
                                   userIDs: [String],
                                   callback: CreateGroupCallback? = nil) {
        ZIMKitCore.shared.createGroup(with: groupName,
                                      groupID: groupID,
                                      userIDs: userIDs,
                                      callback: callback)
    }
    
    /// Join the group chat
    /// - Parameters:
    ///   - groupID: group ID
    ///   - callback: callback for the results that whether the group chat is joined successfully.
    public static func joinGroup(by groupID: String, callback: JoinGroupCallback? = nil) {
        ZIMKitCore.shared.joinGroup(by: groupID, callback: callback)
    }
    
    public static func leaveGroup(by groupID: String, callback: LeaveGroupCallback? = nil) {
        ZIMKitCore.shared.leaveGroup(by: groupID, callback: callback)
    }
    
    public static func inviteUsersToJoinGroup(with inviteUserIDs: [String],
                                              groupID: String,
                                              callback: InviteUsersToJoinGroupCallback? = nil) {
        ZIMKitCore.shared.inviteUsersToJoinGroup(with: inviteUserIDs,
                                                 groupID: groupID,
                                                 callback: callback)
    }
    
    // 用于群聊的时候查询群名称和头像
    public static func queryGroupInfo(by groupID: String,
                                      callback: QueryGroupInfoCallback? = nil) {
        ZIMKitCore.shared.queryGroupInfo(by: groupID, callback: callback)
    }
    
    // 群聊的时候使用, 需要将返回的数据缓存到业务层
    // 如果没有缓存则调用此接口请求群成员信息(用于显示群消息的昵称和头像)
    public static func queryGroupMemberInfo(by userID: String,
                                            groupID: String,
                                            callback: QueryGroupMemberInfoCallback? = nil) {
        ZIMKitCore.shared.queryGroupMemberInfo(by: userID, groupID: groupID, callback: callback)
    }
}
