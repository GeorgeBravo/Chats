// 
//  RootComponent+ChatList.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Root to provide for the ChatList scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyChatList: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the ChatList scope.
}

extension RootComponent: ChatListDependency {

    // TODO: Implement properties to provide for ChatList scope.
}
