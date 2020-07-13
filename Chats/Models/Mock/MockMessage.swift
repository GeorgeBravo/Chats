/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import CoreLocation
import AVFoundation
import UIKit
import Photos

public struct CoordinateItem: LocationItem {
    public var location: CLLocation
}

public struct AssetMediaItem: MediaItem {
    public var asset: PHAsset
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

struct MockContactItem: ContactItem {
    
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
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
            return ChatTableViewTextMessageCellModel(message: message, timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage)
        case let .location(locationItem):
            return ChatTableViewLocationCellModel(locationItem: locationItem, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage)
        case let .asset(assets):
            return ChatTableViewAssetCellModel(assets: assets, timestamp: Date(), profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage)
        default:
            return ChatTableViewTextMessageCellModel(message: "", timestamp: sentDate, profileImage: UIImage(named: "roflan"), isMessageRead: arc4random_uniform(2) == 0, isIncomingMessage: isIncomingMessage)
            
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
    
    init(assets: [AssetMediaItem], user: MockUser, messageId: String, date: Date, isIncomingMessage: Bool) {
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
    
    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date) {
        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
    }
}
