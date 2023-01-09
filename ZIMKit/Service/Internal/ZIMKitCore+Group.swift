//
//  ZIMKitCore+Group.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/9.
//

import Foundation
import ZIM

extension ZIMKitCore {
    func createGroup(with groupName: String,
                     groupID: String,
                     userIDs: [String],
                     callback: CreateGroupCallback? = nil) {
        let info = ZIMGroupInfo()
        info.groupName = groupName
        info.groupID = groupID
        zim?.createGroup(with: info, userIDs: userIDs, callback: { fullInfo, _, errorUserList, error in
            let info = GroupInfo(with: fullInfo)
            callback?(info, errorUserList, error)
        })
    }
    
    func joinGroup(by groupID: String, callback: JoinGroupCallback? = nil) {
        zim?.joinGroup(by: groupID, callback: { fullInfo, error in
            let info = GroupInfo(with: fullInfo)
            callback?(info, error)
        })
    }
    
    func leaveGroup(by groupID: String, callback: LeaveGroupCallback? = nil) {
        zim?.leaveGroup(by: groupID, callback: { groupID, error in
            callback?(error)
        })
    }
    
    func inviteUsersToJoinGroup(with inviteUserIDs: [String],
                                groupID: String,
                                callback: InviteUsersToJoinGroupCallback? = nil) {
        zim?.inviteUsersIntoGroup(with: inviteUserIDs, groupID: groupID, callback: { groupID, groupMemberInfos, errorUserInfos, error in
            let members = groupMemberInfos.compactMap { GroupMember(with: $0) }
            callback?(members, errorUserInfos, error)
        })
    }
    
    func queryGroupInfo(by groupID: String,
                        callback: QueryGroupInfoCallback? = nil) {
        zim?.queryGroupInfo(by: groupID, callback: { fullInfo, error in
            let groupInfo = GroupInfo(with: fullInfo)
            callback?(groupInfo, error)
        })
    }
    
    func queryGroupMemberInfo(by userID: String,
                              groupID: String,
                              callback: QueryGroupMemberInfoCallback? = nil) {
        zim?.queryGroupMemberInfo(by: userID, groupID: groupID, callback: { _, zimMemberInfo, error in
            let groupMember = GroupMember(with: zimMemberInfo)
            callback?(groupMember, error)
        })
    }
}
