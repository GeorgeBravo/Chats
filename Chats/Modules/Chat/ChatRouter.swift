// 
//  ChatRouter.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatInteractable: Interactable {
    var router: ChatRouting? { get set }
    var listener: ChatListener? { get set }
}

protocol ChatViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChatRouter: ViewableRouter<ChatInteractable, ChatViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: ChatInteractable, viewController: ChatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ChatRouter: ChatRouting {}
