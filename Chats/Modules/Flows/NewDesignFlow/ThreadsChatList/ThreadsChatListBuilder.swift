// 
//  ThreadsChatListBuilder.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatListDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ThreadsChatListComponent: Component<ThreadsChatListDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ThreadsChatListBuildable: Buildable {
    func build(withListener: ThreadsChatListListener) -> ThreadsChatListRouting
}

final class ThreadsChatListBuilder: Builder<ThreadsChatListDependency> {

    override init(dependency: ThreadsChatListDependency) {
        super.init(dependency: dependency)
    }
}

extension ThreadsChatListBuilder: ThreadsChatListBuildable {

    func build(withListener listener: ThreadsChatListListener) -> ThreadsChatListRouting {
        let component = ThreadsChatListComponent(dependency: dependency)
        let viewController = ThreadsChatListViewController()
        let interactor = ThreadsChatListInteractor(presenter: viewController)
        interactor.listener = listener
        
        let cameraScreenBuilder = CameraScreenBuilder(dependency: component)

        return ThreadsChatListRouter(interactor: interactor, viewController: viewController, cameraScreenBuilder)
    }
}
