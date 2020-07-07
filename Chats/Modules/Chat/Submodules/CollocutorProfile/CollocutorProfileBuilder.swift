// 
//  CollocutorProfileBuilder.swift
//  Chats
//
//  Created by user on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol CollocutorProfileDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class CollocutorProfileComponent: Component<CollocutorProfileDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol CollocutorProfileBuildable: Buildable {
    func build(withListener: CollocutorProfileListener, profile: Collocutor) -> CollocutorProfileRouting
}

final class CollocutorProfileBuilder: Builder<CollocutorProfileDependency> {

    override init(dependency: CollocutorProfileDependency) {
        super.init(dependency: dependency)
    }
}

extension CollocutorProfileBuilder: CollocutorProfileBuildable {

    func build(withListener listener: CollocutorProfileListener, profile: Collocutor) -> CollocutorProfileRouting {
        let component = CollocutorProfileComponent(dependency: dependency)
        let viewController = CollocutorProfileViewController()
        let interactor = CollocutorProfileInteractor(presenter: viewController, profile: profile)
        interactor.listener = listener
        
        return CollocutorProfileRouter(interactor: interactor, viewController: viewController)
    }
}
