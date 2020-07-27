//
//  ChatListTableViewSectionModel.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

class ChatListTableViewSectionModel: TableViewSectionModel {
    var headerViewType: TableViewSectionType
    var title: String
    var cellModels: [TableViewCellModel]
    
    init(headerViewType: TableViewSectionType, title: String, cellModels: [TableViewCellModel]) {
        self.headerViewType = headerViewType
        self.title = title
        self.cellModels = cellModels
    }
}
