//
//  DescriptionTableViewCellModel.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct DescriptionTableViewCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .description }
    var description: String
    var isShortcut: Bool
    
    // MARK: - Init
    init(description: String, isShortcut: Bool) {
        self.description = description
        self.isShortcut = isShortcut
    }
}
