//
//  AddContactsTableViewCellModel.swift
//  Chats
//
//  Created by user on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct AddContactsTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { return .addContacts }
    var imageName: String?
    var addContactsText: String
    
    init(imageName: String?, addContactsText: String) {
        self.imageName = imageName
        self.addContactsText = addContactsText
    }
}
