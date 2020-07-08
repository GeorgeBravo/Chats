//
//  CollocutorInfo.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct CollocutorInfoCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .collocutorInfo }
    var name: String
    var image: UIImage
    var fontSize: CGFloat
    
    // MARK: - Inits
    init(name: String, image: UIImage, fontSize: CGFloat) {
        self.name = name
        self.image = image
        self.fontSize = fontSize
    }
    
    init(collocutor: Collocutor, fontSize: CGFloat) {
        name = collocutor.name
        image = collocutor.collocutorImage
        self.fontSize = fontSize
    }
}
