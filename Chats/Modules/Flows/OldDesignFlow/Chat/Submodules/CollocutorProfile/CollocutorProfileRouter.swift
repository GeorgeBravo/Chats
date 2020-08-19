// 
//  CollocutorProfileRouter.swift
//  Chats
//
//  Created by user on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol CollocutorProfileInteractable: Interactable {
    var router: CollocutorProfileRouting? { get set }
    var listener: CollocutorProfileListener? { get set }
}

protocol CollocutorProfileViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CollocutorProfileRouter: ViewableRouter<CollocutorProfileInteractable, CollocutorProfileViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: CollocutorProfileInteractable, viewController: CollocutorProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension CollocutorProfileRouter: CollocutorProfileRouting {}
