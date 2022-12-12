//
//  ZegoSignalingProvider+Extension.swift
//  ZegoPluginAdapter
//
//  Created by Kael Ding on 2022/12/11.
//

import Foundation
import ZegoPluginAdapter

extension ZegoSignalingProvider: ZegoPluginProvider {
    public func getPlugin() -> ZegoPluginProtocol? {
        ZegoSignalingPlugin.shared
    }
}
