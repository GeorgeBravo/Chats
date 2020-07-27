// 
//  ChatComponent+CollocutorProfile.swift
//  Chats
//
//  Created by user on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Chat to provide for the CollocutorProfile scope.
// TODO: Update ChatDependency protocol to inherit this protocol.
protocol ChatDependencyCollocutorProfile: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Chat to provide dependencies
    // for the CollocutorProfile scope.
}

extension ChatComponent: CollocutorProfileDependency {

    // TODO: Implement properties to provide for CollocutorProfile scope.
}
