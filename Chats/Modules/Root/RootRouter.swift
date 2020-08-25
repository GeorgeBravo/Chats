//
//  RootRouter.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck
import UIKit

protocol RootInteractable: Interactable, ChatListListener, ThreadsChatListListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    // TODO: Constructor inject child builder protocols to allow building children.

    private var currentRouter: ViewableRouting? {
        willSet {
            guard let oldRouter = currentRouter else { return }
            detach(oldRouter)
        }
    }
    
    // MARK: - Chat List
    var chatListBuildable: ChatListBuildable
    var threadsChatListBuildable: ThreadsChatListBuildable

    // MARK: - Transition Properties
    fileprivate var targetRouter: ViewableRouting?
    fileprivate lazy var animationInProgress = false
    
    // MARK: - Init
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        _ threadsChatListBuildable: ThreadsChatListBuildable,
        _ chatListBuildable: ChatListBuildable
    ) {
        self.chatListBuildable = chatListBuildable
        self.threadsChatListBuildable = threadsChatListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
}

extension RootRouter: RootRouting {
    func showThreadsChatList() {
        let threadsChatListRouter = threadsChatListBuildable.build(withListener: self.interactor)
        attach(threadsChatListRouter)
        
        replace(threadsChatListRouter, animated: false, embedInNavigationController: true)
        currentRouter = threadsChatListRouter
    }
    
    func showChatList() {
        let chatListRouter = chatListBuildable.build(withListener: self.interactor)

        attach(chatListRouter)

        replace(chatListRouter, animated: false, embedInNavigationController: true)
        currentRouter = chatListRouter
    }
}

extension RootRouter {
    fileprivate typealias Completion = () -> Void

    fileprivate func replace(_ router: ViewableRouting?, animated: Bool = true, embedInNavigationController: Bool = false, completion: Completion? = nil) {
        targetRouter = router
        if animationInProgress {
            completion?()
            return
        }

        let currentVC = viewControllable
        if currentVC.presentedViewController != nil {
            animationInProgress = true
            DispatchQueue.main.async {
                currentVC.dismiss(animated: animated) { [weak self] in
                    guard let self = self else { return }
                    if self.targetRouter != nil {
                        self.presentTargetRouter(embedInNavigationController, completion: completion)
                    } else {
                        self.animationInProgress = false
                        completion?()
                    }
                }
            }
        } else {
            presentTargetRouter(embedInNavigationController, completion: completion)
        }
    }

    private func presentTargetRouter(_ embedInNavigationController: Bool, completion: Completion?) {
        guard let targetRouter = targetRouter else {
            completion?()
            return
        }

        animationInProgress = true
        let vc: UIViewController
        if embedInNavigationController {
            vc = UINavigationController(rootViewController: targetRouter.viewControllable)
        } else {
            vc = targetRouter.viewControllable
        }

        DispatchQueue.main.async {
            vc.modalPresentationStyle = .fullScreen
            self.viewControllable.present(vc, animated: true) { [weak self] in
                self?.animationInProgress = false
                completion?()
            }
        }
    }
}
