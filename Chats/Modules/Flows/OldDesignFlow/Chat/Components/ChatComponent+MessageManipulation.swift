// 
//  ChatComponent+MessageManipulation.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Chat to provide for the MessageManipulation scope.
// TODO: Update ChatDependency protocol to inherit this protocol.
protocol ChatDependencyMessageManipulation: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Chat to provide dependencies
    // for the MessageManipulation scope.
}

extension ChatComponent: MessageManipulationDependency {

    // TODO: Implement properties to provide for MessageManipulation scope.
}
