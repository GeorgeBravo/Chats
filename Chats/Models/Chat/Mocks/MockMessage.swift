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
    
    var tableViewCellViewModel: ChatTableViewCellModel { get }
    
    var sentDate: Date { get set }
}

struct MockMessage: MessageType, ChatScreenDisplayingItems {
    
    var messageId: String
    var sender: SenderType {
        return user
    }
    
    var sentDate: Date
    var kind: MessageKind
    
    var user: MockUser
    
    var isIncomingMessage: Bool
    
    var chatType: ChatType {
        return .oneToOne
    }
    
    var tableViewCellViewModel: ChatTableViewCellModel {
        switch self.kind {
        case let .text(message):
            return ChatTableViewTextMessageCellModel(message: message, timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        case let .location(locationItem):
            return ChatTableViewLocationCellModel(locationItem: locationItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        case let .asset(assets):
            return ChatTableViewAssetCellModel(assets: assets, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        case let .fileItem(fileItem):
            return ChatTableViewFileCellModel(fileItem: fileItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        case let .contact(contact):
            return ChatTableViewContactCellModel(contact: contact, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        default:
            return ChatTableViewTextMessageCellModel(message: "", timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0)
        }
    }
    
    private init(kind: MessageKind, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool = false) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
        self.isIncomingMessage = isIncomingMessage
    }
    
    init(custom: Any?, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }
    
    init(text: String, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date, isIncomingMessage: isIncomingMessage)
    }
    
    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }
    
    init(assets: AssetMediaItem, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
        self.init(kind: .asset(assets), user: user, messageId: messageId, date: date, isIncomingMessage: isIncomingMessage)
    }
    
    init(location: LocationItem, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
        self.init(kind: .location(location), user: user, messageId: messageId, date: date)
    }
    
    init(emoji: String, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
    }
    
    init(audioURL: URL, user: MockUser, messageId: String, date: Date) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
    }
    
    init(contact: ContactItem, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
    }
    
    init(fileItem: FileItem, user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
        self.init(kind: .fileItem(fileItem), user: user, messageId: messageId, date: date, isIncomingMessage: isIncomingMessage)
    }
}
