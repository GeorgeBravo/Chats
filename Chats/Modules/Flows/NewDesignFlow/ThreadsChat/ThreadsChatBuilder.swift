// 
//  ThreadsChatBuilder.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ThreadsChatComponent: Component<ThreadsChatDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ThreadsChatBuildable: Buildable {
    func build(withListener: ThreadsChatListener, withVC: ThreadsChatListViewControllable) -> ThreadsChatRouting
}

final class ThreadsChatBuilder: Builder<ThreadsChatDependency> {

    override init(dependency: ThreadsChatDependency) {
        super.init(dependency: dependency)
    }
}

extension ThreadsChatBuilder: ThreadsChatBuildable {
    func build(withListener listener: ThreadsChatListener, withVC: ThreadsChatListViewControllable) -> ThreadsChatRouting {
        let component = ThreadsChatComponent(dependency: dependency)
        let viewController = ThreadsChatViewController()
        viewController.transitioningDelegate = viewController.transitionController
        if let chatListVC = withVC as? ThreadsChatListViewController {
             viewController.transitionController.fromDelegate = chatListVC
        }
        let interactor = ThreadsChatInteractor(presenter: viewController)
        interactor.listener = listener
        
        return ThreadsChatRouter(interactor: interactor, viewController: viewController)
    }
}
