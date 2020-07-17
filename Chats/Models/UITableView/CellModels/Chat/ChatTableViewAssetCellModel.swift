//
//  ChatTableViewAssetCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewAssetCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .assets }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var assets: MediaItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool

    init(assets: MediaItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool, isMessageEdited: Bool) {
        self.assets = assets
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
    }
}
