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
    case chatList
    case collocutorInfo
}

extension TableViewCellType {
    static let allTypes = TableViewCellType.allCases
        .compactMap { $0.classType }
    
    var classType: UITableViewCell.Type {
        switch self {
        case .collocutorOption: return ActionTableViewCell.self
        case .chatList: return ChatListTableViewCell.self
        case .collocutorInfo: return CollocutorProfileTableViewCell.self
        }
    }
}

protocol TableViewCellSetup {
    func setup(with viewModel: TableViewCellModel)
}

protocol TableViewCellModel {
    var cellType: TableViewCellType! { get }
}
