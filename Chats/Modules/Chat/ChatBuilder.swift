// 
//  ChatBuilder.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ChatComponent: Component<ChatDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ChatBuildable: Buildable {
    func build(withListener: ChatListener, of type: ChatType) -> ChatRouting
}

final class ChatBuilder: Builder<ChatDependency> {

    override init(dependency: ChatDependency) {
        super.init(dependency: dependency)
    }
}

extension ChatBuilder: ChatBuildable {

    func build(withListener listener: ChatListener, of type: ChatType) -> ChatRouting {
        let component = ChatComponent(dependency: dependency)
        let viewController = ChatViewController(with: type)
        let interactor = ChatInteractor(presenter: viewController)
        interactor.listener = listener

        let collocutorProfileBuilder = CollocutorProfileBuilder(dependency: component)
        let groupProfileBuilder = GroupProfileBuilder(dependency: component)
        return ChatRouter(interactor: interactor, viewController: viewController, collocutorProfileBuilder, groupProfileBuilder)
    }
}
