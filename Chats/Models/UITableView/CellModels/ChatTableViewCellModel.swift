//
//  ChatTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

protocol ChatTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { get }
    
    var isMessageRead: Bool { get }
    var isIncomingMessage: Bool { get }
    var timestamp: Date { get }
}
