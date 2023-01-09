//
//  ZIMKit.swift
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation
import ZegoPluginAdapter

public class ZIMKit: NSObject {
        
    /// Initialize the ZIMKit.
    /// You will need to initialize the ZIMKit SDK before calling methods.
    /// - Parameters:
    ///   - appID: appID. To get this, go to ZEGOCLOUD Admin Console (https://console.zegocloud.com/).
    ///   - appSign: appSign. To get this, go to ZEGOCLOUD Admin Console (https://console.zegocloud.com/).
    public static func initWith(appID: UInt32, appSign: String) {
        ZIMKitCore.shared.initWith(appID: appID, appSign: appSign)
    }
    
    public static func registerZIMKitDelegate(_ delegate: ZIMKitDelegate) {
        ZIMKitCore.shared.registerZIMKitDelegate(delegate)
    }
}
