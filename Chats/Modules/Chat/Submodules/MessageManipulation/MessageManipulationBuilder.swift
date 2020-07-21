// 
//  MessageManipulationBuilder.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol MessageManipulationDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class MessageManipulationComponent: Component<MessageManipulationDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol MessageManipulationBuildable: Buildable {
    func build(withListener: MessageManipulationListener, chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues) -> MessageManipulationRouting
}

final class MessageManipulationBuilder: Builder<MessageManipulationDependency> {

    override init(dependency: MessageManipulationDependency) {
        super.init(dependency: dependency)
    }
}

extension MessageManipulationBuilder: MessageManipulationBuildable {

    func build(withListener listener: MessageManipulationListener, chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues) -> MessageManipulationRouting {
        let component = MessageManipulationComponent(dependency: dependency)
        let viewController = MessageManipulationViewController()
        let interactor = MessageManipulationInteractor(presenter: viewController, chatTableViewCellModel: chatTableViewCellModel, cellNewFrame: cellNewFrame)
        interactor.listener = listener

        return MessageManipulationRouter(interactor: interactor, viewController: viewController)
    }
}
