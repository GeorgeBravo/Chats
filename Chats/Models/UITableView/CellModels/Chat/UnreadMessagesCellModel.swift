//
//  UnreadMessagesCellModel.swift
//  Chats
//
//  Created by user on 30.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

public struct UnreadMessagesCellModel: ChatTableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .unreadMessages }
    var title: String
    var timestamp: Date
    
    // MARK: - Init
    init(unreadMessagesModel: UnreadMessagesModel, timestamp: Date) {
        self.title = unreadMessagesModel.title
        self.timestamp = timestamp
    }
}
