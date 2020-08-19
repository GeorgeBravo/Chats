// 
//  ChatComponent+GroupProfile.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Chat to provide for the GroupProfile scope.
// TODO: Update ChatDependency protocol to inherit this protocol.
protocol ChatDependencyGroupProfile: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Chat to provide dependencies
    // for the GroupProfile scope.
}

extension ChatComponent: GroupProfileDependency {

    // TODO: Implement properties to provide for GroupProfile scope.
}
