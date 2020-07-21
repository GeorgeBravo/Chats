//
//  MessageManipulationSectionModel.swift
//  Chats
//
//  Created by user on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct MessageManipulationTableViewSectionModel: TableViewSectionModel {
    
    // MARK: - Variable
    var headerViewType: TableViewSectionType { return .messageManipulation }
    var title: String
    var cellModels: [TableViewCellModel]
    var widthConstant: CGFloat
    var heightConstant: CGFloat
    var fillColorName: ColorName?
    
    init(title: String, cellModels: [TableViewCellModel], widthConstant: CGFloat, heightConstant: CGFloat, fillColorName: ColorName?) {
        self.title = title
        self.cellModels = cellModels
        self.widthConstant = widthConstant
        self.heightConstant = heightConstant
        self.fillColorName = fillColorName
    }
}
