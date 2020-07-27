//
//  OptionsTableViewSectionModel.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

class OptionsTableViewSectionModel: TableViewSectionModel {
    var headerViewType: TableViewSectionType
    
    var title: String
    
    var cellModels: [TableViewCellModel]
    
    init(headerViewType: TableViewSectionType, title: String, cellModels: [TableViewCellModel]) {
        self.headerViewType = headerViewType
        self.title = title
        self.cellModels = cellModels
    }
}
