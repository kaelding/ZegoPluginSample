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
import ZIM

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        ZIMKit.initWith(appID: 2031514356,
                        appSign: "d0e83faa119daa065ae553fb23c68a3e624a1f879d5fb2d0c24e066d9859d214")
        ZIMKit.registerZIMKitDelegate(self)
        ZIMKit.connectUser(userInfo: UserInfo("222222", "Kael")) { error in
            if error.code == .success {
                print("connectUser success.")
                ZIMKit.sendTextMessage("123", to: "22222", type: .peer) { message, error in
                    print(message.info)
                }
            } else {
                print("connectUser fail.")
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 注册插件到Adapter
//        let plugins: [ZegoPluginProtocol] = [ZegoCallKitPlugin.shared, ZegoSignalingPlugin.shared]
//        ZegoPluginAdapter.installPlugins(plugins)

        // 通过type获取已经注册的插件, 并转换类型
//        let signaling = ZegoPluginAdapter.signalingPlugin
//        // 调用插件方法
//        signaling?.initWith(appID: 123, appSign: "123")
//        signaling?.sendInvitation(with: ["123"], timeout: 60, data: nil, callback: nil)
        
    }
}

extension ViewController: ZIMKitDelegate {
    func onPreMessageSending(_ message: ZIMMessage) {
        guard let message = message as? ZIMTextMessage else { return }
        message.message = "Text"
    }
}

