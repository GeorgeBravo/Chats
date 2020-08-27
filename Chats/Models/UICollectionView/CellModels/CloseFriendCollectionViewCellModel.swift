//
//  CloseFriendCollectionViewCellModel.swift
//  Chats
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class CloseFriendCollectionViewCellModel: CollectionViewCellModel {
    
    // MARK: - Variables
    var cellType: CollectionViewCellType { return .closeFriend }
    var isPhotoCellModel: Bool
    var userImage: UIImage?
    var buttonWidth: CGFloat
    
    // MARK: - Init
    init(userImage: UIImage?, isPhotoCellModel: Bool = false, buttonWidth: CGFloat = 0.0) {
        self.userImage = userImage
        self.isPhotoCellModel = isPhotoCellModel
        self.buttonWidth = buttonWidth
    }
    
}
