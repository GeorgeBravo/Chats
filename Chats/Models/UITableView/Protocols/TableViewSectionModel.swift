//
//  TableViewSectionModel.swift
//  Chats
//
//  Created by Касилов Георгий on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

protocol TableViewSectionModel {
    var headerViewType: TableViewSectionType { get }
    var title: String { get set }
    var cellModels: [TableViewCellModel] { get set }
}
