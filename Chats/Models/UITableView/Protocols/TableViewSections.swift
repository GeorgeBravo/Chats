//
//  NableViewSections.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

enum TableViewSectionType {
    case options
    case collocutorProfile
    case messagesTimestamp
    case chatList
    
    var classType: UITableViewHeaderFooterView.Type? {
        switch self {
        case .options: return OptionSectionHeaderView.self
        case .collocutorProfile: return OptionSectionHeaderView.self
        case .chatList: return ChatListSectionHeaderView.self
        case .messagesTimestamp: return ChatSectionHeaderView.self
        }
    }
}
