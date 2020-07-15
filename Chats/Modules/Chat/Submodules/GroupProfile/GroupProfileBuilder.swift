// 
//  GroupProfileBuilder.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol GroupProfileDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class GroupProfileComponent: Component<GroupProfileDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol GroupProfileBuildable: Buildable {
    func build(withListener: GroupProfileListener) -> GroupProfileRouting
}

final class GroupProfileBuilder: Builder<GroupProfileDependency> {

    override init(dependency: GroupProfileDependency) {
        super.init(dependency: dependency)
    }
}

extension GroupProfileBuilder: GroupProfileBuildable {

    func build(withListener listener: GroupProfileListener) -> GroupProfileRouting {
        let component = GroupProfileComponent(dependency: dependency)
        let viewController = GroupProfileViewController()
        let interactor = GroupProfileInteractor(presenter: viewController)
        interactor.listener = listener

        return GroupProfileRouter(interactor: interactor, viewController: viewController)
    }
}
