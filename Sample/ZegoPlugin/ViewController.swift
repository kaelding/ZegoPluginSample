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
import Photos
import PhotosUI
import MobileCoreServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        ZIMKit.initWith(appID: 2031514356,
                        appSign: "d0e83faa119daa065ae553fb23c68a3e624a1f879d5fb2d0c24e066d9859d214")
        ZIMKit.registerZIMKitDelegate(self)
        
        let userInfo = UserInfo(userID: "222222", userName: "Kael")
        ZIMKit.connectUser(userInfo: userInfo) { error in
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
    
    @IBAction func takePhoto(_ sender: Any) {
        DispatchQueue.main.async {
            if #available(iOS 17.0, *) {
                var config = PHPickerConfiguration()
                config.filter = PHPickerFilter.any(of: [.images, .videos, .livePhotos])
                config.selectionLimit = 9
                config.preferredAssetRepresentationMode = .current

                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                //                picker.modalPresentationStyle = .fullScreen
                self.present(picker, animated: true)
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let picker = UIImagePickerController()
                    //                    picker.modalPresentationStyle = .fullScreen
                    picker.sourceType = .savedPhotosAlbum
                    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? ["public.image"]
                    picker.delegate = self
                    self.present(picker, animated: true)
                }
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

extension ViewController: ZIMKitDelegate, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
        if results.count == 0 { return }

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    guard let url = url else { return }
                    ZIMKit.sendImageMessage(url.path, to: "333333", type: .peer)
                }
            } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                // if use `loadItem` may get a empty file
                // use load file will copy the video to a temp folder
                // and the `preferredAssetRepresentationMode` should set to `current`
                // or it will cost a few seconds to handle the video to `compatible`
                // Ref: https://developer.apple.com/forums/thread/652695
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                    guard let url = url else { return }
                    ZIMKit.sendVideoMessage(url.path, to: "333333", type: .peer)
                }
            }
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.delegate = nil
        picker.dismiss(animated: true) { [weak self] in
            guard let mediaType = info[.mediaType] as? String else { return }
            if mediaType as CFString == kUTTypeImage {
                guard let url = info[.imageURL] as? URL else { return }
                ZIMKit.sendImageMessage(url.path, to: "333333", type: .peer)
                print("Pick an image.")
            } else if mediaType as CFString == kUTTypeMovie {
                print("Pick a video.")
                if let url = info[.mediaURL] as? URL {
                    ZIMKit.sendVideoMessage(url.path, to: "333333", type: .peer)
                }
                
            }
        }
    }
    
    func onPreMessageSending(_ message: ZIMMessage) {
        guard let message = message as? ZIMTextMessage else { return }
        message.message = "Text"
    }
}

