// 
//  ThreadsChatRouter.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatInteractable: Interactable {
    var router: ThreadsChatRouting? { get set }
    var listener: ThreadsChatListener? { get set }
}

protocol ThreadsChatViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadsChatRouter: ViewableRouter<ThreadsChatInteractable, ThreadsChatViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: ThreadsChatInteractable, viewController: ThreadsChatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ThreadsChatRouter: ThreadsChatRouting {}
