//
//  CollectionViewCellType.swift
//  Chats
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

enum CollectionViewCellType {
    case closeFriend
    
    var classType: UICollectionViewCell.Type {
        switch self {
        case .closeFriend: return CloseFriendCollectionViewCell.self
        }
    }
}
