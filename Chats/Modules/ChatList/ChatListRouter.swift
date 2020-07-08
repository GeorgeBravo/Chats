// 
//  ChatListRouter.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatListInteractable: Interactable {
    var router: ChatListRouting? { get set }
    var listener: ChatListListener? { get set }
}

protocol ChatListViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChatListRouter: ViewableRouter<ChatListInteractable, ChatListViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: ChatListInteractable, viewController: ChatListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ChatListRouter: ChatListRouting {}
