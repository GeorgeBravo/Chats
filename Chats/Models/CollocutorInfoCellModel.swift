//
//  CollocutorInfo.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

typealias OnCollocutorManipulationPressClosure = ((CollocutorManipulations) -> Void)

struct CollocutorInfoCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .collocutorInfo }
    var name: String
    var image: UIImage
    var fontSize: CGFloat
    var lastSeenDescriptionText: String
    var manipulationCallback: OnCollocutorManipulationPressClosure?
    
    // MARK: - Inits
    init(name: String, image: UIImage, fontSize: CGFloat, lastSeenDescriptionText: String) {
        self.name = name
        self.image = image
        self.fontSize = fontSize
        self.lastSeenDescriptionText = lastSeenDescriptionText
    }
    
    init(collocutor: Collocutor, fontSize: CGFloat, lastSeenDescriptionText: String) {
        name = collocutor.name
        image = collocutor.collocutorImage
        self.fontSize = fontSize
        self.lastSeenDescriptionText = lastSeenDescriptionText
    }
}
