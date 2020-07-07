//
//  ActionTableViewCellModel.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

enum CollocutorOptionCellAppearance {
    case standard
    case arrowCell
    case destructive
}

enum CollocutorOptionType: String {
    case sendMessage = "Send Message"
    case addToContacts = "Add to Contacts"
    case addToGroups = "Add to Groups"
    case sharedMedia = "Shared Media"
    case notification = "Notifications"
    case groupsInCommon = "Groups In Common"
    case blockUser = "Block User"
    case username = "@username"
    
    var cellAppearance: CollocutorOptionCellAppearance {
        switch self {
        case .sendMessage: return .standard
        case .addToContacts: return .standard
        case .addToGroups: return .standard
        case .sharedMedia: return .arrowCell
        case .notification: return .arrowCell
        case .groupsInCommon: return .arrowCell
        case .blockUser: return .destructive
        case .username: return .standard
        }
    }
    
    var buttonTextColor: UIColor {
        switch self.cellAppearance {
        case .arrowCell: return UIColor.optionsBlackColor
        case .destructive: return UIColor.optionsRedColor
        case .standard: return UIColor.optionsBlueColor
        }
    }
}

struct ActionTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { return .collocutorOption }
    var title: String?
    var imageLink: String?
    var optionType: CollocutorOptionType
    
    init(optionType: CollocutorOptionType) {
        title = optionType.rawValue
        self.optionType = optionType
    }
}
