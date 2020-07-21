//
//  ChatTableViewFileCellModel.swift
//  Chats
//
//  Created by Mykhailo H on 7/14/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct ChatTableViewFileCellModel: ChatContentTableViewCellModel {

    var cellType: TableViewCellType! { return .file }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var file: FileItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    var isMessageEdited: Bool

    var messageSelection: MessageSelection?
    
    var chatType: ChatType

    // MARK: - Init
    
    init(fileItem: FileItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool, isMessageEdited: Bool, chatType: ChatType) {
        self.file = fileItem
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
        self.isMessageEdited = isMessageEdited
        self.chatType = chatType
    }
}
