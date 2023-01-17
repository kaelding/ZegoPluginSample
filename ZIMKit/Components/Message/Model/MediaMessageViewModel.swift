//
//  MediaMessageViewModel.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/16.
//

import Foundation
import ZIM

class MediaMessageViewModel: MessageViewModel {
    /// Returns `true` if the media message is downloading.
    @Observable var isDownloading: Bool = false
    
    /// The media file local path of the message.
    @Observable var fileLocalPath: String = "" {
        didSet {
            let msg = message.zim as? ZIMMediaMessage
            msg?.fileLocalPath = fileLocalPath
        }
    }
}
