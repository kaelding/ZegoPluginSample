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
    
    // 静态属性, 调用方式为 ZegoPluginAdapter.signalingPlugin
    // 其他端没有可以改为 getSignalingPlugin() 方法
    public static var signalingPlugin: ZegoSignalingPluginProtocol? {
        return getPlugin(.signaling) as? ZegoSignalingPluginProtocol
    }
    
    private static func getPlugin(_ type: ZegoPluginType) -> ZegoPluginProtocol? {
        // get plugin from ZegoPluginAdapter
        if let plugin = ZegoPluginAdapter.shared.plugins[type] {
            return plugin
        }
        
        // get plugin from PluginProvider
        let provider = getPluginProvider(with: type)
        guard let plugin = provider?.getPlugin() else {
            return nil
        }
        // install plugin into ZegoPluginAdapter
        // and will get plugin from ZegoPluginAdapter next time.
        ZegoPluginAdapter.installPlugins([plugin])
        return plugin
    }
    
    private static func getPluginProvider(with type: ZegoPluginType) -> ZegoPluginProvider? {
        switch type {
        case .signaling:
            return ZegoSignalingProvider() as? ZegoPluginProvider
        case .callkit:
            return ZegoCallKitProvider() as? ZegoPluginProvider
        case .beauty:
            return ZegoBeautyProvider() as? ZegoPluginProvider
        case .whiteboard:
            return ZegoWhiteboardProvider() as? ZegoPluginProvider
        }
    }
}
