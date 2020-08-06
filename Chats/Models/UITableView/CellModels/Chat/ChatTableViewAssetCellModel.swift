//
//  ChatTableViewAssetCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewAssetCellModel: ChatContentTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .assets }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var assets: MediaItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool

    var messageSelection: MessageSelection?
    var chatType: ChatType
    var needHideMessage: Bool
    var isPinned: Bool
    var messageId: String
    var messageCornerRoundedType: MessageCornerRoundedType
    
    // MARK: - Init
    init(assets: MediaItem,
         timestamp: Date,
         profileImage: UIImage?,
         isMessageRead: Bool,
         isIncomingMessage: Bool,
         isMessageEdited: Bool,
         chatType: ChatType,
         needHideMessage: Bool,
         isPinned: Bool = false,
         messageId: String,
         messageCornerRoundedType: MessageCornerRoundedType) {
        self.assets = assets
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
        self.chatType = chatType
        self.needHideMessage = needHideMessage
        self.isPinned = isPinned
        self.messageId = messageId
        self.messageCornerRoundedType = messageCornerRoundedType
    }
}
