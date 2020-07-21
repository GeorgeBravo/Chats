//
//  ChatTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

protocol ChatTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { get }
    
    var timestamp: Date { get }
}

