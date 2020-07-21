//
//  MockMessage.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation
import UIKit
import Photos

public struct CoordinateItem: LocationItem {
    public var location: CLLocation
}

public struct AssetMediaItem: MediaItem {
    public var assets: [PHAsset]?
    public var imageData: Data?
    public var videoURL: URL?
}

private struct MockAudiotem: AudioItem {
    
    var url: URL
    var size: CGSize
    var duration: Float
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        // compute duration
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }
    
}

protocol ChatScreenDisplayingItems {
    var sentDate: Date { get set }
    var kind: MessageKind { get }
    
    var chatType: ChatType { get }
}

struct MockMessage: ChatScreenDisplayingItems {
    
    var sentDate: Date
    var kind: MessageKind
    
    var isIncomingMessage: Bool
    
    var chatType: ChatType {
        return .oneToOne
    }
    
    var tableViewCellViewModel: ChatTableViewCellModel {
        switch self.kind {
        case let .text(message):
            return ChatTableViewTextMessageCellModel(message: message, timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        case let .location(locationItem):
            return ChatTableViewLocationCellModel(locationItem: locationItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        case let .asset(assets):
            return ChatTableViewAssetCellModel(assets: assets, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        case let .fileItem(fileItem):
            return ChatTableViewFileCellModel(fileItem: fileItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        case let .contact(contact):
            return ChatTableViewContactCellModel(contact: contact, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        case let .addUserToChat(model):
            return UserChatEntryTableViewCellModel(userInviteModel: model, timestamp: Date())
        default:
            return ChatTableViewTextMessageCellModel(message: "", timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType)
        }
    }
    
    private  init(kind: MessageKind, date: Date, isIncomingMessage: Bool = false, chatType: ChatType) {
        self.kind = kind
        self.sentDate = date
        self.isIncomingMessage = isIncomingMessage
    }
    
    init(text: String, date: Date, isIncomingMessage: Bool, chatType: ChatType) {
        self.init(kind: .text(text), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType)
    }
    
    init(assets: AssetMediaItem, date: Date, isIncomingMessage: Bool, chatType: ChatType) {
        self.init(kind: .asset(assets), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType)
    }
    
    init(location: LocationItem, date: Date, isIncomingMessage: Bool, chatType: ChatType) {
        self.init(kind: .location(location), date: date, chatType: chatType)
    }
    
    init(audioURL: URL, date: Date, chatType: ChatType) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), date: date, chatType: chatType)
    }
    
    init(contact: ContactItem, date: Date, isIncomingMessage: Bool, chatType: ChatType) {
        self.init(kind: .contact(contact), date: date, chatType: chatType)
    }
    
    init(fileItem: FileItem, date: Date, isIncomingMessage: Bool, chatType: ChatType) {
        self.init(kind: .fileItem(fileItem), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType)
    }
    
    init(model: UserInviteModel, date: Date, chatType: ChatType) {
        self.init(kind: .addUserToChat(model), date: date, chatType: chatType)
    }
}
