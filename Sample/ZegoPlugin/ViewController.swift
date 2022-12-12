//
//  ViewController.swift
//  ZegoPlugin
//
//  Created by Kael Ding on 2022/12/5.
//

import UIKit

import ZIMKit
import ZegoCallKit
import ZegoPluginAdapter
import ZegoSignalingPlugin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 注册插件到Adapter
//        let plugins: [ZegoPluginProtocol] = [ZegoCallKitPlugin.shared, ZegoSignalingPlugin.shared]
//        ZegoPluginAdapter.installPlugins(plugins)

        // 通过type获取已经注册的插件, 并转换类型
        let signaling = ZegoPluginAdapter.getPlugin(.signaling) as? ZegoSignalingPluginProtocol
        // 调用插件方法
        signaling?.initWith(appID: 123, appSign: "123")
        signaling?.sendInvitation(with: ["123"], timeout: 60, data: nil, callback: nil)
        
        
        ZIMKit.initWith(appID: 1234, appSign: "123")
        ZIMKit.connectUser(userInfo: UserInfo("123", "123")) { error in
            if error.code == 0 {
                print("connectUser success.")
            }
        }
    }
}

