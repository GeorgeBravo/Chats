// 
//  GroupProfileRouter.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol GroupProfileInteractable: Interactable {
    var router: GroupProfileRouting? { get set }
    var listener: GroupProfileListener? { get set }
}

protocol GroupProfileViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class GroupProfileRouter: ViewableRouter<GroupProfileInteractable, GroupProfileViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: GroupProfileInteractable, viewController: GroupProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension GroupProfileRouter: GroupProfileRouting {}
