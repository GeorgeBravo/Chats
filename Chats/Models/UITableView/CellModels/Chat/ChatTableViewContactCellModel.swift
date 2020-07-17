//
//  ChatTableViewContactCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewContactCellModel: ChatTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .contact }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var contact: ContactItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool
    var messageSelection: MessageSelection?
    
    // MARK: - Init
    init(contact: ContactItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool, isMessageEdited: Bool) {
        self.contact = contact
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
    }
    
}
