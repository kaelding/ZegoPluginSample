//
//  VideoMessage.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/17.
//

import Foundation
import ZIM

class VideoMessageViewModel: MediaMessageViewModel {
    override init(with msg: ZIMKitMessage) {
        super.init(with: msg)
        
        if msg.info.sentStatus == .sendFailed {
            let url = URL(fileURLWithPath: msg.videoContent.fileLocalPath)
            let videoInfo = AVTool.getFirstFrameImageAndDuration(with: url)
            msg.videoContent.firstFrameSize = videoInfo.image?.size ?? .zero
            msg.videoContent.firstFrameLocalPath = url.deletingPathExtension().path + ".png"
            if !ImageCache.containsCachedImage(for: msg.videoContent.firstFrameLocalPath) {
                ImageCache.storeImage(image: videoInfo.image, for: msg.videoContent.firstFrameLocalPath)
            }
        }
    }

    convenience init(with fileLocalPath: String, duration: UInt32, firstFrameLocalPath: String) {
        let msg = ZIMKitMessage()
        msg.videoContent.fileLocalPath = fileLocalPath
        msg.videoContent.duration = duration
        msg.videoContent.firstFrameLocalPath = firstFrameLocalPath
        self.init(with: msg)
    }

    override var contentSize: CGSize {
        if _contentSize == .zero {
            _contentSize = getScaleImageSize(message.videoContent.firstFrameSize.width, message.videoContent.firstFrameSize.height)
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
