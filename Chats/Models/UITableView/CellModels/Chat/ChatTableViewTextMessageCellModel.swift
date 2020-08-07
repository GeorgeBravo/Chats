//
//  ChatTableViewTextMessageCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewTextMessageCellModel: ChatContentTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .textMessage }
    
    var message: String
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool
    var isPinned: Bool
    var messageId: String
    
    var messageSelection: MessageSelection?
    var needHideMessage: Bool
    
    var chatType: ChatType
    var messageCornerRoundedType: MessageCornerRoundedType
    
    // MARK: - Init
    init(message: String,
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
        self.message = message
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
