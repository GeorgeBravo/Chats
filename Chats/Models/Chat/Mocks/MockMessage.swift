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
    var messageKind: MessageKind { get }
    
    var chatType: ChatType { get }
    
    var messageId: String { get }
}


struct MockMessage: ChatScreenDisplayingItems {

    // MARK: Internal variables
    var sentDate: Date
    var messageKind: MessageKind
    
    var isIncomingMessage: Bool
    
    var chatType: ChatType = .oneToOne
    
    var needHideMessage: Bool = false
    
    var messageId: String
    
    var isPinned = false
    
    var tableViewCellViewModel: ChatTableViewCellModel {
        switch self.messageKind {
        case let .text(message):
            return ChatTableViewTextMessageCellModel(message: message, timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        case let .location(locationItem):
            return ChatTableViewLocationCellModel(locationItem: locationItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        case let .asset(assets):
            return ChatTableViewAssetCellModel(assets: assets, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        case let .fileItem(fileItem):
            return ChatTableViewFileCellModel(fileItem: fileItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        case let .contact(contact):
            return ChatTableViewContactCellModel(contact: contact, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        case let .addUserToChat(model):
            return UserChatEntryTableViewCellModel(userInviteModel: model, timestamp: Date())
        case let .unreadMessage(model):
            return UnreadMessagesCellModel(unreadMessagesModel: model, timestamp: Date())
        default:
            return ChatTableViewTextMessageCellModel(message: "", timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage, isMessageEdited: arc4random_uniform(2) == 0, chatType: chatType, needHideMessage: needHideMessage, isPinned: isPinned, messageId: messageId)
        }
    }
    
    // MARK: Public
    
    public mutating func setNeedHideMessage(_ needHideMessage: Bool) {
        self.needHideMessage = needHideMessage
    }
    
    // MARK: - Initialization
    private init(messageKind: MessageKind, date: Date, isIncomingMessage: Bool = true, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.messageKind = messageKind
        self.sentDate = date
        self.isIncomingMessage = isIncomingMessage
        self.needHideMessage = needHideMessage
        self.chatType = chatType
        self.messageId = messageId
    }

    init(text: String, date: Date, isIncomingMessage: Bool, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .text(text), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(assets: AssetMediaItem, date: Date, isIncomingMessage: Bool, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .asset(assets), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(location: LocationItem, date: Date, isIncomingMessage: Bool, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .location(location), date: date, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(audioURL: URL, date: Date, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(messageKind: .audio(audioItem), date: date, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(contact: ContactItem, date: Date, isIncomingMessage: Bool, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .contact(contact), date: date, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(fileItem: FileItem, date: Date, isIncomingMessage: Bool, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .fileItem(fileItem), date: date, isIncomingMessage: isIncomingMessage, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(model: UserInviteModel, date: Date, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .addUserToChat(model), date: date, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
    init(unreadModel: UnreadMessagesModel, date: Date, chatType: ChatType, needHideMessage: Bool = false, messageId: String) {
        self.init(messageKind: .unreadMessage(unreadModel), date: date, chatType: chatType, needHideMessage: needHideMessage, messageId: messageId)
    }
    
}
