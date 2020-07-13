//
//  CollocutorInfo.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

typealias OnCollocutorManipulationPressClosure = ((CollocutorOptionType) -> Void)

struct CollocutorInfoCellModel: TableViewCellModel {
    
    // MARK: - Variables
    var cellType: TableViewCellType! { return .collocutorInfo }
    var name: String
    var image: UIImage
    var lastSeenDescriptionText: String
    var manipulationCallback: OnCollocutorManipulationPressClosure?
    
    // MARK: - Inits
    init(name: String, image: UIImage, lastSeenDescriptionText: String) {
        self.name = name
        self.image = image
        self.lastSeenDescriptionText = lastSeenDescriptionText
    }
    
    init(collocutor: Collocutor, lastSeenDescriptionText: String) {
        name = collocutor.name
        image = collocutor.collocutorImage
        self.lastSeenDescriptionText = lastSeenDescriptionText
    }
}
