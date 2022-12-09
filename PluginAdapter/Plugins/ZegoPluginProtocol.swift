//
//  ZegoPluginProtocol.swift
//  ZegoPluginProtocol
//
//  Created by Kael Ding on 2022/12/5.
//

import Foundation

public protocol ZegoPluginProtocol {
    var pluginType: ZegoPluginType { get }
    var version: String { get }
}
