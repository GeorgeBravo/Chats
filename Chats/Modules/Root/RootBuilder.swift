//
//  RootBuilder.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class RootComponent: Component<RootDependency> {
    let rootViewController: RootViewController

    init(dependency: RootDependency, rootViewController: RootViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> RootRouting
}

final class RootBuilder: Builder<RootDependency> {
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
}

extension RootBuilder: RootBuildable {
    func build() -> RootRouting {
        let viewController = RootViewController()
        let component = RootComponent(dependency: dependency, rootViewController: viewController)
        let interactor = RootInteractor(presenter: viewController)
        
        let chatBuilder = ChatBuilder(dependency: component)
        let chatListBuilder = ChatListBuilder(dependency: component)

        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          chatBuilder,
                          chatListBuilder)
    }
}
