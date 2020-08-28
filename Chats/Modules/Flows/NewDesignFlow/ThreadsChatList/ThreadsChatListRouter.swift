// 
//  ThreadsChatListRouter.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatListInteractable: Interactable, ThreadsChatListener, CameraScreenListener {
    var router: ThreadsChatListRouting? { get set }
    var listener: ThreadsChatListListener? { get set }
}

protocol ThreadsChatListViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ThreadsChatListRouter: ViewableRouter<ThreadsChatListInteractable, ThreadsChatListViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.
    
    // MARK: - Variables
    private var currentRouter: ViewableRouting? {
        willSet {
            guard let oldRouter = currentRouter else { return }
            detach(oldRouter)
        }
    }
    
    private var cameraScreenBuilder: CameraScreenBuildable
    private var cameraScreenRouter: ViewableRouting?
    
    private var threadsChatBuilder: ThreadsChatBuildable
    private var threadsChatRouter: ViewableRouting?
    
    private var chatListVC: ThreadsChatListViewControllable
    
    // MARK: - Init
    init(
        interactor: ThreadsChatListInteractable,
        viewController: ThreadsChatListViewControllable,
        _ cameraScreenBuilder: CameraScreenBuildable,
        _ threadsChatBuilder: ThreadsChatBuildable
    ) {
        self.chatListVC = viewController
        self.threadsChatBuilder = threadsChatBuilder
        self.cameraScreenBuilder = cameraScreenBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ThreadsChatListRouter: ThreadsChatListRouting {
    func openChatScreen() {
        let threadsChatRouter = threadsChatBuilder.build(withListener: interactor, withVC: chatListVC)
        self.threadsChatRouter = threadsChatRouter
        
        attach(threadsChatRouter)
        present(threadsChatRouter, animated: true, modalPresentationStyle: .custom)
    }
    
    func showCameraScreen() {
        let cameraScreenRouter = cameraScreenBuilder.build(withListener: interactor)
        self.cameraScreenRouter = cameraScreenRouter
        
        attach(cameraScreenRouter)
        pushRouter(cameraScreenRouter, animated: false)
    }
    
    func hideCameraScreen() {
        guard let cameraScreenRouter = cameraScreenRouter else { return }

        detach(cameraScreenRouter)
        cameraScreenRouter.popRouter(animated: false)
        self.cameraScreenRouter = nil
    }
}
