//
//  ChatListTableViewCellModel.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct ChatListTableViewCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .chatList }
    var title: String?
    var collocutorName: String?
    var message: String?
    var timeSent: String?
    var sentDate: Date?
    var imageLink: String?
    var isSelected: Bool?
    var messageCount: Int?
    var isEditing: Bool?
    var id: Int?
    var isGroupChat: Bool?
    var lastSender: String?
    var membersCount: Int?
    var membersOnline: Int?
    
    // MARK: - Logic
    func timeText() -> String? {
        guard let sentDate = sentDate else { return nil }
        return sentDate.createdDateText().dateText
    }
    
    func isWeekendDate() -> Bool {
        guard let sentDate = sentDate else { return false }
        return sentDate.createdDateText().isWeekend
    }
}
