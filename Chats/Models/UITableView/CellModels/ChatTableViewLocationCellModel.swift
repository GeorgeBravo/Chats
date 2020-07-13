//
//  ChatTableViewLocationCellModel.swift
//  Chats
//
//  Created by Касилов Георгий on 10.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import CoreLocation
import UIKit

struct ChatTableViewLocationCellModel: ChatTableViewCellModel {
    var cellType: TableViewCellType! { return .location }
    
    var timestamp: Date
    var profileImage: UIImage?
    
    var locationItem: LocationItem
    
    var isMessageRead: Bool
    var isIncomingMessage: Bool
    
    init(locationItem: LocationItem, timestamp: Date, profileImage: UIImage?, isMessageRead: Bool, isIncomingMessage: Bool) {
        self.locationItem = locationItem
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.isMessageRead = isMessageRead
        self.isIncomingMessage = isIncomingMessage
    }
}

