//
//  ZegoCallKitService.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation
import ZegoPluginAdapter

public class ZegoCallKitService: NSObject {
    public static let shared = ZegoCallKitService()
    
    public func sendInvitation(_ invitees: [String], timeout: UInt32, data: String?, callback: InvitationCallback?) {
        let signaling = ZegoPluginAdapter.signalingPlugin
        signaling?.sendInvitation(with: invitees, timeout: timeout, data: data, notificationConfig: nil, callback: callback)
    }
}
