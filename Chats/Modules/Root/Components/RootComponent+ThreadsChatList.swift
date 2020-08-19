// 
//  RootComponent+ThreadsChatList.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Root to provide for the ThreadsChatList scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyThreadsChatList: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the ThreadsChatList scope.
}

extension RootComponent: ThreadsChatListDependency {

    // TODO: Implement properties to provide for ThreadsChatList scope.
}
