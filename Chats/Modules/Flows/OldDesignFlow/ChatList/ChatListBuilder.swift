// 
//  ChatListBuilder.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatListDependency: Dependency {

    // TODO: Declare the set of dependencies required by this BRIck, but cannot be created by this BRIck.
}

final class ChatListComponent: Component<ChatListDependency> {

    // TODO: Declare `fileprivate` dependencies that are only used by this BRIck.
}

// MARK: - Builder

protocol ChatListBuildable: Buildable {
    func build(withListener: ChatListListener) -> ChatListRouting
}

final class ChatListBuilder: Builder<ChatListDependency> {

    override init(dependency: ChatListDependency) {
        super.init(dependency: dependency)
    }
}

extension ChatListBuilder: ChatListBuildable {

    func build(withListener listener: ChatListListener) -> ChatListRouting {
        let component = ChatListComponent(dependency: dependency)
        let viewController = ChatListViewController()
        let interactor = ChatListInteractor(presenter: viewController)
        interactor.listener = listener
        
        let chatBuilder = ChatBuilder(dependency: component)

        return ChatListRouter(interactor: interactor,
                              viewController: viewController,
                              chatBuilder)
    }
}
