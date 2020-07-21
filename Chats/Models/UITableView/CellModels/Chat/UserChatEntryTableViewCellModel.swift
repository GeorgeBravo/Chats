//
//  UserChatEntryTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct UserChatEntryTableViewCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .userChatEntry }
    
    var userInviteModel: UserInviteModel
    
    var timestamp: Date
    
    init(userInviteModel: UserInviteModel,
         timestamp: Date) {
        self.userInviteModel = userInviteModel
        self.timestamp = timestamp
    }
}
