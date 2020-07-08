//
//  ActionTableViewCellModel.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
//import UIKit

enum CollocutorOptionCellAppearance {
    case standard
    case arrowCell
    case destructive
}

enum CollocutorOptionType: Int {
    case addToContacts
    case addToGroups
    case blockUser
    case groupsInCommon
    case notification
    case sendMessage
    case sharedMedia
    case username
    
    var stringDescription: String {
        switch self {
        case .addToContacts: return LocalizationKeys.addToContacts.localized()
        case .addToGroups: return LocalizationKeys.addToGroups.localized()
        case .blockUser: return LocalizationKeys.blockUser.localized()
        case .groupsInCommon: return LocalizationKeys.groupsInCommon.localized()
        case .notification: return LocalizationKeys.notifications.localized()
        case .sendMessage: return LocalizationKeys.sendMessage.localized()
        case .sharedMedia: return LocalizationKeys.sharedMedia.localized()
        case .username: return LocalizationKeys.username.localized()
        }
    }
    
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
    
    var buttonTextColorName: ColorName {
        switch self.cellAppearance {
        case .arrowCell: return ColorName.optionsBlackColor
        case .destructive: return ColorName.optionsRedColor
        case .standard: return ColorName.optionsBlueColor
        }
    }
}

struct ActionTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { return .collocutorOption }
    var title: String?
    var descriptionText: String?
    var optionType: CollocutorOptionType
    
    init(optionType: CollocutorOptionType, descriptionText: String? = nil) {
        title = optionType.stringDescription
        self.descriptionText = descriptionText
        self.optionType = optionType
    }
}
