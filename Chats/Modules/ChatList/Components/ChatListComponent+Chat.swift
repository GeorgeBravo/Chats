// 
//  ChatListComponent+Chat.swift
//  Chats
//
//  Created by Касилов Георгий on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of ChatList to provide for the Chat scope.
// TODO: Update ChatListDependency protocol to inherit this protocol.
protocol ChatListDependencyChat: Dependency {
    // TODO: Declare dependencies needed from the parent scope of ChatList to provide dependencies
    // for the Chat scope.
}

extension ChatListComponent: ChatDependency {

    // TODO: Implement properties to provide for Chat scope.
}
