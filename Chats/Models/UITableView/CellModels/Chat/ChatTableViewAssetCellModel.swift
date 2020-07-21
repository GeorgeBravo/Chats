//
//  ChatTableViewAssetCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewAssetCellModel: ChatTableViewCellModel {
    
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
    
    // MARK: - Init
    init(assets: MediaItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool, isMessageEdited: Bool, chatType: ChatType, needHideMessage: Bool) {
        self.assets = assets
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
        self.chatType = chatType
        self.needHideMessage = needHideMessage
    }
}
