//
//  ChatTableViewTextMessageCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewTextMessageCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .textMessage }
    
    var message: String
    var timestamp: Date
    var profileImage: UIImage?
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    
    init(message: String, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool) {
        self.message = message
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
    }
}
