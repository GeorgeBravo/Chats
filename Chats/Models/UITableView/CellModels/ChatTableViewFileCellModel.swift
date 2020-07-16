//
//  ChatTableViewFileCellModel.swift
//  Chats
//
//  Created by Mykhailo H on 7/14/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

struct ChatTableViewFileCellModel : ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .file }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var file: FileItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    
    init(fileItem: FileItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool) {
        self.file = fileItem
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
    }
}
