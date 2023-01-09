//
//  ZIMKitMessage+Extension.swift
//  ZIMKit
//
//  Created by Kael Ding on 2023/1/6.
//

import Foundation
import ZIM

extension ZIMKitMessage {
    func update(with zim: ZIMMessage) {
        type = zim.type
        
        info.messageID = zim.messageID
        info.localMessageID = zim.localMessageID
        info.senderUserID = zim.senderUserID
        info.conversationID = zim.conversationID
        info.conversationType = zim.conversationType
        info.direction = zim.direction
        info.sentStatus = zim.sentStatus
        info.timestamp = zim.timestamp
        info.conversationSeq = zim.conversationSeq
        info.orderKey = zim.orderKey
        info.isUserInserted = zim.isUserInserted
        
        if let zim = zim as? ZIMTextMessage {
            textContent.content = zim.message
        }
        
        if let zim = zim as? ZIMSystemMessage {
            systemContent.content = zim.message
        }
        
        if let zim = zim as? ZIMImageMessage {
            imageContent.fileLocalPath = zim.fileLocalPath
            imageContent.fileDownloadUrl = zim.fileDownloadUrl
            imageContent.fileUID = zim.fileUID
            imageContent.fileName = zim.fileName
            imageContent.fileSize = zim.fileSize
            imageContent.thumbnailDownloadUrl = zim.thumbnailDownloadUrl
            imageContent.thumbnailLocalPath = zim.thumbnailLocalPath
            imageContent.largeImageDownloadUrl = zim.largeImageDownloadUrl
            imageContent.largeImageLocalPath = zim.largeImageLocalPath
            imageContent.originalSize = zim.originalImageSize
            imageContent.largeSize = zim.largeImageSize
            imageContent.thumbnailSize = zim.thumbnailSize
        }
        
        if let zim = zim as? ZIMAudioMessage {
            audioContent.fileLocalPath = zim.fileLocalPath
            audioContent.fileDownloadUrl = zim.fileDownloadUrl
            audioContent.fileUID = zim.fileUID
            audioContent.fileName = zim.fileName
            audioContent.fileSize = zim.fileSize
            audioContent.duration = zim.audioDuration
        }
        
        if let zim = zim as? ZIMVideoMessage {
            videoContent.fileLocalPath = zim.fileLocalPath
            videoContent.fileDownloadUrl = zim.fileDownloadUrl
            videoContent.fileUID = zim.fileUID
            videoContent.fileName = zim.fileName
            videoContent.fileSize = zim.fileSize
            videoContent.duration = zim.videoDuration
            videoContent.firstFrameDownloadUrl = zim.videoFirstFrameDownloadUrl
            videoContent.firstFrameLocalPath = zim.videoFirstFrameLocalPath
            videoContent.firstFrameSize = zim.videoFirstFrameSize
        }
        
        if let zim = zim as? ZIMFileMessage {
            fileContent.fileLocalPath = zim.fileLocalPath
            fileContent.fileDownloadUrl = zim.fileDownloadUrl
            fileContent.fileUID = zim.fileUID
            fileContent.fileName = zim.fileName
            fileContent.fileSize = zim.fileSize
        }
    }
    
    func updateUploadProgress(currentSize: UInt64, totalSize: UInt64) {
        switch type {
        case .audio:
            audioContent.uploadProgress = .init(currentSize, totalSize)
        case .video:
            videoContent.uploadProgress = .init(currentSize, totalSize)
        case .image:
            imageContent.uploadProgress = .init(currentSize, totalSize)
        case .file:
            fileContent.uploadProgress = .init(currentSize, totalSize)
        default:
            break
        }
    }
    
    func updateDownloadProgress(currentSize: UInt64, totalSize: UInt64) {
        switch type {
        case .audio:
            audioContent.downloadProgress = .init(currentSize, totalSize)
        case .video:
            videoContent.downloadProgress = .init(currentSize, totalSize)
        case .image:
            imageContent.downloadProgress = .init(currentSize, totalSize)
        case .file:
            fileContent.downloadProgress = .init(currentSize, totalSize)
        default:
            break
        }
    }
}
