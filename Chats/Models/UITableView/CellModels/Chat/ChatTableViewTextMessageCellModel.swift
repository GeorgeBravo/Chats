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
    
    var messageSelection: MessageSelection?
    
    var chatType: ChatType
    

    // MARK: - Init
    
    init(message: String, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool, isMessageEdited: Bool, chatType: ChatType) {
        self.message = message
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
        self.chatType = chatType
    }
}
