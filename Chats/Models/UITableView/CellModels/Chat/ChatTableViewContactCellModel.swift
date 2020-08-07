//
//  ChatTableViewContactCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewContactCellModel: ChatContentTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .contact }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var contact: ContactItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool
    var isPinned: Bool
    var messageId: String
    
    var chatType: ChatType
    var messageCornerRoundedType: MessageCornerRoundedType

    var messageSelection: MessageSelection?
    var needHideMessage: Bool
    
    // MARK: - Init
    init(contact: ContactItem,
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
        self.contact = contact
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
