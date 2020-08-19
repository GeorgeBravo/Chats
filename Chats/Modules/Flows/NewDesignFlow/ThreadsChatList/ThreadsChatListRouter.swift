// 
//  ThreadsChatListRouter.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatListInteractable: Interactable, ThreadsChatListener {
    var router: ThreadsChatListRouting? { get set }
    var listener: ThreadsChatListListener? { get set }
}

protocol ThreadsChatListViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadsChatListRouter: ViewableRouter<ThreadsChatListInteractable, ThreadsChatListViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: ThreadsChatListInteractable, viewController: ThreadsChatListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ThreadsChatListRouter: ThreadsChatListRouting {}
