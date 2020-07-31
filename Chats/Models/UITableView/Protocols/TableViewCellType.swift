//
//  CellModel.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

enum TableViewCellType: CaseIterable {
    case collocutorOption
    case collocutorInfo
    case chatList
    case textMessage
    case location
    case assets
    case file
    case description
    case groupInfo
    case user
    case addContacts
    case contact
    case messageManipulation
    case userChatEntry
    case unreadMessages
}

extension TableViewCellType {
    static let allTypes = TableViewCellType.allCases
        .compactMap { $0.classType }
    
    var classType: UITableViewCell.Type {
        switch self {
        case .collocutorOption: return ActionTableViewCell.self
        case .collocutorInfo: return CollocutorProfileTableViewCell.self
        case .chatList: return ChatListTableViewCell.self
        case .textMessage: return TextMessageCell.self
        case .location: return LocationMessageCell.self
        case .assets: return MediaMessageCell.self
        case .description: return DescriptionTableViewCell.self
        case .groupInfo: return GroupProfileTableViewCell.self
        case .user: return UserTableViewCell.self
        case .addContacts: return AddContactsTableViewCell.self
        case .file: return FileMessageCell.self
        case .contact: return ContactMessageCell.self
        case .messageManipulation: return MessageManipulationTableViewCell.self
        case .userChatEntry: return UserChatEntryTableViewCell.self
        case .unreadMessages: return UnreadMessagesTableViewCell.self
        }
    }
}
