// 
//  CameraScreenRouter.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol CameraScreenInteractable: Interactable {
    var router: CameraScreenRouting? { get set }
    var listener: CameraScreenListener? { get set }
}

protocol CameraScreenViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CameraScreenRouter: ViewableRouter<CameraScreenInteractable, CameraScreenViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    override init(interactor: CameraScreenInteractable, viewController: CameraScreenViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension CameraScreenRouter: CameraScreenRouting {}
