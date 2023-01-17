//
//  ImageMessage.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/16.
//

import Foundation
import ZIM
import UIKit

class ImageMessageViewModel: MediaMessageViewModel {

    /// Is this image gif.
    var isGif: Bool {
        let url = URL(fileURLWithPath: message.fileName)
        return url.pathExtension.lowercased() == "gif"
    }

    override init(with msg: ZIMKitMessage) {
        super.init(with: msg)
        
        let fileLocalPath = msg.imageContent.fileLocalPath
        if fileLocalPath.count > 0 &&
            !FileManager.default.fileExists(atPath: fileLocalPath) {
            // image will use ImageCache data, not the file.
            let home = NSHomeDirectory()
            msg.imageContent.fileLocalPath = home + fileLocalPath[home.endIndex..<fileLocalPath.endIndex]
        }
        
        if msg.info.sentStatus == .sendFailed && msg.imageContent.fileLocalPath.count > 0 {
            ImageCache.cachedImage(for: msg.imageContent.fileLocalPath, isSync: true) { image in
                msg.imageContent.originalSize = image?.size ?? .zero
            }
        }
    }
    
    convenience init(with fileLocalPath: String) {
        let msg = ZIMKitMessage()
        msg.imageContent.fileLocalPath = fileLocalPath
        self.init(with: msg)
    }

    override var contentSize: CGSize {
        if _contentSize == .zero {
            _contentSize = getScaleImageSize(message.imageContent.originalSize.width, message.imageContent.originalSize.height)
        }
        return _contentSize
    }

    func getScaleImageSize(_ w: CGFloat, _ h: CGFloat) -> CGSize {

        var w = w
        var h = h

        let maxWH = UIScreen.main.bounds.width / 2.0
        let minWH = UIScreen.main.bounds.width / 4.0

        if w == 0 && h == 0 {
            return CGSize(width: maxWH, height: maxWH)
        }

        if w > h {
            h = h / w * maxWH
            h = max(h, minWH)
            w = maxWH
        } else {
            w = w / h * maxWH
            w = max(w, minWH)
            h = maxWH
        }

        return CGSize(width: w, height: h)
    }
}
