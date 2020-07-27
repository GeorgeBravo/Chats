//
//  ChatTableViewLocationCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 10.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewLocationCellModel: ChatContentTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .location }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var locationItem: LocationItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool
    
    var messageSelection: MessageSelection?
    var needHideMessage: Bool
    var isPinned: Bool
    var messageId: String
    
    var chatType: ChatType
    

    // MARK: - Init
    init(locationItem: LocationItem,
         timestamp: Date,
         profileImage: UIImage?,
         isMessageRead: Bool,
         isIncomingMessage: Bool,
         isMessageEdited: Bool,
         chatType: ChatType,
         needHideMessage: Bool,
         isPinned: Bool = false,
         messageId: String) {
        self.locationItem = locationItem
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
        self.chatType = chatType
        self.needHideMessage = needHideMessage
        self.isPinned = isPinned
        self.messageId = messageId
    }
}

