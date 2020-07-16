//
//  MockUser.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
