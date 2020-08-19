// 
//  ThreadsChatListComponent+ThreadsChat.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of ThreadsChatList to provide for the ThreadsChat scope.
// TODO: Update ThreadsChatListDependency protocol to inherit this protocol.
protocol ThreadsChatListDependencyThreadsChat: Dependency {
    // TODO: Declare dependencies needed from the parent scope of ThreadsChatList to provide dependencies
    // for the ThreadsChat scope.
}

extension ThreadsChatListComponent: ThreadsChatDependency {

    // TODO: Implement properties to provide for ThreadsChat scope.
}
