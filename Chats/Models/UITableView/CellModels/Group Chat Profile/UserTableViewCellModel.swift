//
//  UserTableViewCell.swift
//  Chats
//
//  Created by user on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct UserTableViewCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .user }
    var imageName: String?
    var userNameText: String
    var lastPresenceText: String
    var isOnline: Bool
    var isAuthor: Bool
    
    // MARK: - Init
    init(imageName: String?,
         userNameText: String,
         lastPresenceText: String,
         isOnline: Bool,
         isAuthor: Bool) {
        self.imageName = imageName
        self.userNameText = userNameText
        self.lastPresenceText = lastPresenceText
        self.isOnline = isOnline
        self.isAuthor = isAuthor
    }
}
