//
//  ZegoCallKitPluginProtocol.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation

public protocol ZegoCallKitPluginProtocol: ZegoPluginProtocol {
    func initWithAppID(_ appID: UInt32, appSign: String, userID: String, userName: String)
    
    // type: 0 - voice, 1 - video
    func startCall(_ invitees: [String], timeout: UInt, type: UInt)
    
    func endCall()
}
