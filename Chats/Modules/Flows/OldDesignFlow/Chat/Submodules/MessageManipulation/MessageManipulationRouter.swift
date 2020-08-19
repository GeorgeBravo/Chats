// 
//  MessageManipulationRouter.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol MessageManipulationInteractable: Interactable {
    var router: MessageManipulationRouting? { get set }
    var listener: MessageManipulationListener? { get set }
}

protocol MessageManipulationViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MessageManipulationRouter: ViewableRouter<MessageManipulationInteractable, MessageManipulationViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: MessageManipulationInteractable, viewController: MessageManipulationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension MessageManipulationRouter: MessageManipulationRouting {}
