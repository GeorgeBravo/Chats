//
//  MessageManipulationTableViewCellModel.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

enum MessageManipulationType {
    case answer
    case copy
    case change
    case pin
    case unpin
    case forward
    case reply
    case delete
    case more
    
    var stringDescription: String {
        switch self {
        case .answer: return LocalizationKeys.answer.localized()
        case .copy: return LocalizationKeys.copy.localized()
        case .change: return LocalizationKeys.change.localized()
        case .pin: return LocalizationKeys.pin.localized()
        case .unpin: return LocalizationKeys.unpin.localized()
        case .forward: return LocalizationKeys.forward.localized()
        case .reply: return LocalizationKeys.reply.localized()
        case .delete: return LocalizationKeys.delete.localized()
        case .more: return LocalizationKeys.moreManipulations.localized()
        }
    }
    
    var image: UIImage {
        switch self {
        default: return #imageLiteral(resourceName: "newChatIcon")
        }
    }
}

typealias MessageManipulationAction = ((MessageManipulationType) -> ())
class MessageManipulationTableViewCellModel: TableViewCellModel {

    // MARK: - Variables
    var cellType: TableViewCellType! { return .messageManipulation }

    var manipulationType: MessageManipulationType
    var isFirstOption: Bool
    var isLastOption: Bool
    var manipulationAction: MessageManipulationAction?

    // MARK: - Init
    init(messageManipulationType: MessageManipulationType,
         isFirstOption: Bool = false,
         isLastOption: Bool = false) {
        manipulationType = messageManipulationType
        self.isFirstOption = isFirstOption
        self.isLastOption = isLastOption
    }
    
    // MARK: - Logic
    func messageManipulationTapped() {
        manipulationAction?(manipulationType)
    }
}
