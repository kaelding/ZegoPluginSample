//
//  ZIMKitCore.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/8.
//

import Foundation
import ZIM
import ZegoSignalingPlugin

class ZIMKitCore: NSObject {
    static let shared = ZIMKitCore()
    
    var zim: ZIM? = nil
    
    var userInfo: ZIMKitUserInfo?
    
    lazy var dataPath: String = {
        let path = NSHomeDirectory() + "/Documents/ZIMKitSDK/" + (userInfo?.id ?? "temp")
        return path
    }()
    
    var conversations: [ZIMKitConversation] = []
    
    var messageList: MessageList = MessageList()
    
    var isLoadedAllConversations = false
    
    let delegates: NSHashTable<ZIMKitDelegate> = NSHashTable(options: .weakMemory)
    
    func initWith(appID: UInt32, appSign: String) {
        ZegoSignalingPlugin.shared.initWith(appID: appID, appSign: appSign)
        zim = ZIM.shared()
        ZegoSignalingPlugin.shared.registerZIMEventHandler(self)
    }
    
    func registerZIMKitDelegate(_ delegate: ZIMKitDelegate) {
        delegates.add(delegate)
    }
}
