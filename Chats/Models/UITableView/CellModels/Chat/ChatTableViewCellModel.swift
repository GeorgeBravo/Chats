//
//  ChatTableViewCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

protocol ChatTableViewCellModel: TableViewCellModel {
    var cellType: TableViewCellType! { get }
    
    var isMessageRead: Bool { get }
    var isIncomingMessage: Bool { get }
    var isMessageEdited: Bool { get }
    
    var timestamp: Date { get }
    var profileImage: UIImage? { get }
    
    var chatType: ChatType { get }
}
