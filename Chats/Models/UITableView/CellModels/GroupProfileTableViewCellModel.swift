//
//  GroupProfileTableViewCellModel.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct GroupProfileTableViewCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .groupInfo }
    var imageName: String?
    var groupNameText: String
    var membersCountText: String
    
    // MARK: - Init
    init(imageName: String?, groupNameText: String, membersCountText: String) {
        self.imageName = imageName
        self.groupNameText = groupNameText
        self.membersCountText = membersCountText
    }
    
}
