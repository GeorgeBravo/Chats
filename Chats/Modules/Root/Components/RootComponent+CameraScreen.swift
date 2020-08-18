// 
//  RootComponent+CameraScreen.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

/// The dependencies needed from the parent scope of Root to provide for the CameraScreen scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyCameraScreen: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the CameraScreen scope.
}

extension RootComponent: CameraScreenDependency {

    // TODO: Implement properties to provide for CameraScreen scope.
}
