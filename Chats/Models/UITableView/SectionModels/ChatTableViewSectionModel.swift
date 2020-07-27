//
//  ChatTableViewSectionModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

final class ChatTableViewSectionModel: TableViewSectionModel {
    enum ChatHeaderType {
        case simple
        case bubble
    }
    
    var headerStyle: ChatHeaderType
    
    var headerViewType: TableViewSectionType
    
    var title: String
    
    var cellModels: [TableViewCellModel]
    
    init(headerViewType: TableViewSectionType, title: String, cellModels: [TableViewCellModel], headerStyle: ChatHeaderType) {
        self.headerViewType = headerViewType
        self.headerStyle = headerStyle
        self.title = title
        self.cellModels = cellModels
    }
}
