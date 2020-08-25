// 
//  CameraScreenBuilder.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol CameraScreenDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class CameraScreenComponent: Component<CameraScreenDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol CameraScreenBuildable: Buildable {
    func build(withListener: CameraScreenListener) -> CameraScreenRouting
}

final class CameraScreenBuilder: Builder<CameraScreenDependency> {

    override init(dependency: CameraScreenDependency) {
        super.init(dependency: dependency)
    }
}

extension CameraScreenBuilder: CameraScreenBuildable {

    func build(withListener listener: CameraScreenListener) -> CameraScreenRouting {
        let component = CameraScreenComponent(dependency: dependency)
        let viewController = CameraScreenViewController()
        let interactor = CameraScreenInteractor(presenter: viewController)
        interactor.listener = listener
        
        return CameraScreenRouter(interactor: interactor, viewController: viewController)
    }
}
