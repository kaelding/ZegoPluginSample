//
//  ZegoPluginProvider.swift
//  Pods-ZegoPlugin
//
//  Created by Kael Ding on 2022/12/11.
//

import Foundation

public protocol ZegoPluginProvider {
    func getPlugin() -> ZegoPluginProtocol?
}

public struct ZegoSignalingProvider {
    
}

public struct ZegoCallKitProvider {
    
}

public struct ZegoBeautyProvider {
    
}

public struct ZegoWhiteboardProvider {
    
}
