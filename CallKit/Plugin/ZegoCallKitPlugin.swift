//
//  CallKitPlugin.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation
import ZegoPluginAdapter

public class ZegoCallKitPlugin: ZegoCallKitPluginProtocol {
    
    public static let shared = ZegoCallKitPlugin()
    
    public init() {
        
    }
    
    public func initWithAppID(_ appID: UInt32, appSign: String, userID: String, userName: String) {
        
    }
    
    public func startCall(_ invitees: [String], timeout: UInt, type: UInt) {
        
    }
    
    public func endCall() {
        
    }
    
    public var pluginType: ZegoPluginType {
        .callkit
    }
    
    public var version: String {
        "1.0.0"
    }
}
