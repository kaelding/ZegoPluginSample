//
//  ZegoPluginAdapter.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation

public class ZegoPluginAdapter {
    static let shared = ZegoPluginAdapter()
    
    private var plugins = [ZegoPluginType: ZegoPluginProtocol]()
    
    public static func installPlugins(_ plugins: [ZegoPluginProtocol]) {
        for plugin in plugins {
            ZegoPluginAdapter.shared.plugins[plugin.pluginType] = plugin
        }
    }
    
    public static func getPlugin(_ type: ZegoPluginType) -> ZegoPluginProtocol? {
        ZegoPluginAdapter.shared.plugins[type]
    }
}
