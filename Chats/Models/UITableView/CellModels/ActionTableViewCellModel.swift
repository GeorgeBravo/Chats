//
//  ActionTableViewCellModel.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

enum CollocutorOptionCellAppearance {
    case standard
    case arrowCell
    case destructive
}

enum CollocutorOptionType: Int {
    case call
    case search
    case mute
    case more
    case addToContacts
    case addToGroups
    case blockUser
    case leaveGroup
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
        case .leaveGroup: return LocalizationKeys.leaveGroup.localized()
        case .groupsInCommon: return LocalizationKeys.groupsInCommon.localized()
        case .notification: return LocalizationKeys.notifications.localized()
        case .sendMessage: return LocalizationKeys.sendMessage.localized()
        case .sharedMedia: return LocalizationKeys.sharedMedia.localized()
        case .username: return LocalizationKeys.username.localized()
        case .call: return LocalizationKeys.call.localized()
        case .search: return LocalizationKeys.search.localized()
        case .mute: return LocalizationKeys.mute.localized()
        case .more: return LocalizationKeys.more.localized()
        }
    }
    
    var cellAppearance: CollocutorOptionCellAppearance {
        switch self {
        case .sharedMedia: return .arrowCell
        case .notification: return .arrowCell
        case .groupsInCommon: return .arrowCell
        case .blockUser: return .destructive
        case .leaveGroup: return .destructive
        default: return .standard
        }
    }
    
    var buttonTextColorName: ColorName {
        switch self.cellAppearance {
        case .arrowCell: return ColorName.optionsBlackColor
        case .destructive: return ColorName.pinkishRedTwo
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
