//
//  AvatarModel.swift
//  Chats
//
//  Created by Eugene Zatserklyaniy on 27.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit


protocol AvatarModel {
    var isOnline: Bool { get }
}

struct UserAvatarModel: AvatarModel {
    let image: String
    let hasStory: Bool
    let isOnline: Bool
}

struct GroupAvatarModel: AvatarModel {
    let topImage: String
    let bottomImage: String
    let isOnline: Bool
}
