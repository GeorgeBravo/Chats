//
//  ChatTableViewContactCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

struct ChatTableViewContactCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .contact }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var contact: ContactItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool

    init(contact: ContactItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool) {
        self.contact = contact
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
    }
}
