//
//  ChatListTableViewCellModel.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct ChatListTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { return .chatList }
    var title: String?
    var collocutorName: String?
    var message: String?
    var timeSent: String?
    var imageLink: String?
    var isSelected: Bool?
    var messageCount: Int?
    var isEditing: Bool?
    var id: Int?
}
