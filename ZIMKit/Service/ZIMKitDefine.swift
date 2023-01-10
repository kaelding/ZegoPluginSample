//
//  ZIMKitDefine.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/12/8.
//

import Foundation
import ZIM

public typealias ConnectUserCallback = (_ error: ZIMError) -> Void

public typealias UserAvatarUrlUpdateCallback = (_ url: String, _ error: ZIMError) -> Void

public typealias CreateGroupCallback = (_ groupInfo: GroupInfo,
                                        _ errorUserList: [ZIMErrorUserInfo],
                                        _ error: ZIMError) -> Void

public typealias JoinGroupCallback = (_ groupInfo: GroupInfo, _ error: ZIMError) -> Void

public typealias QueryUserCallback = (_ userInfo: UserInfo?,
                                      _ errorUser: ZIMErrorUserInfo?,
                                      _ error: ZIMError) -> Void

public typealias LeaveGroupCallback = (_ error: ZIMError) -> Void

public typealias InviteUsersToJoinGroupCallback = (_ groupMembers: [GroupMember],
                                                   _ errorUserList: [ZIMErrorUserInfo],
                                                   _ error: ZIMError) -> Void

public typealias DeleteConversationCallback = (_ error: ZIMError) -> Void

public typealias ClearUnreadCountCallback = (_ error: ZIMError) -> Void

public typealias GetConversationListCallback = (_ conversations: [ZIMKitConversation],
                                                _ error: ZIMError) -> Void

public typealias LoadMoreConversationCallback = (_ error: ZIMError) -> Void

public typealias MessageSentCallback = (_ message: ZIMKitMessage, _ error: ZIMError) -> Void

public typealias GetMessageListCallback = (_ conversations: [ZIMKitMessage],
                                           _ error: ZIMError) -> Void

public typealias LoadMoreMessageCallback = (_ error: ZIMError) -> Void

public typealias QueryGroupInfoCallback = (_ info: GroupInfo,
                                           _ error: ZIMError) -> Void

public typealias QueryGroupMemberInfoCallback = (_ member: GroupMember,
                                                 _ error: ZIMError) -> Void

public typealias DownloadMediaFileCallback = (_ error: ZIMError) -> Void

public typealias DeleteMessageCallback = (_ error: ZIMError) -> Void
