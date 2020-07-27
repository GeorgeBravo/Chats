//
//  ViewableRouting+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck
// import Layout
import UIKit

extension ViewableRouting {
    func present(_ routerToParent: ViewableRouting,
                 animated flag: Bool,
                 embedInNavigationController: Bool = false,
                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                 completion: (() -> Void)? = nil) {
        let vc: UIViewController
        if embedInNavigationController {
            vc = routerToParent.viewControllable.embedInNavigationController()
        } else {
            vc = routerToParent.viewControllable
        }

        vc.modalPresentationStyle = modalPresentationStyle

        viewControllable.present(vc, animated: flag, completion: completion)
    }

    func presentModally(_ routerToParent: ViewableRouting,
                        animated flag: Bool,
                        embedInNavigationController: Bool = false,
                        modalPresentationStyle: UIModalPresentationStyle = .pageSheet,
                        completion: (() -> Void)? = nil) {
        let vc: UIViewController
        if embedInNavigationController {
            vc = routerToParent.viewControllable.embedInNavigationController()
        } else {
            vc = routerToParent.viewControllable
        }
        
        viewControllable.modalPresentationStyle = modalPresentationStyle
        viewControllable.present(vc, animated: flag, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        viewControllable.dismiss(animated: animated, completion: completion)
    }

    func pushRouter(_ router: ViewableRouting, animated: Bool, embedInNavigationController: Bool = false) {
        DispatchQueue.main.async {
            let navigationController = self.viewControllable.navigationController
            if navigationController != nil {
                let vc: UIViewController
                if embedInNavigationController {
                    vc = router.viewControllable.embedInNavigationController()
                } else {
                    vc = router.viewControllable
                }
                navigationController?.pushViewController(vc, animated: animated)
            } else {
                self.present(router, animated: animated, embedInNavigationController: embedInNavigationController)
            }
        }
    }

    @discardableResult
    func popRouter(animated: Bool, completion: (() -> Void)? = nil) -> ViewableRouting? {
        DispatchQueue.main.async {
            let navigationController = self.viewControllable.navigationController
            if navigationController != nil {
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                navigationController?.popViewController(animated: animated)
                CATransaction.commit()
            } else {
                self.viewControllable.dismiss(animated: animated, completion: completion)
            }
        }
        return self
    }

    @discardableResult
    func popToRoot(animated: Bool) -> ViewableRouting? {
        DispatchQueue.main.async {
            if let navigationController = self.viewControllable.navigationController {
                navigationController.popToRootViewController(animated: animated)
            } else {
                self.viewControllable.dismiss(animated: animated)
            }
        }

        return self
    }

    @available(*, deprecated)
    func show(_ router: ViewableRouting, animated: Bool = true, embedInNavigationController: Bool = false) {
        let vc: UIViewController
        if embedInNavigationController {
            vc = router.viewControllable.embedInNavigationController()
        } else {
            vc = router.viewControllable
        }

        if let navController = viewControllable.navigationController {
            navController.pushViewController(vc, animated: animated)
        } else {
            vc.modalPresentationStyle = .fullScreen
            viewControllable.present(vc, animated: animated)
        }
    }

    @available(*, deprecated)
    func show(_ router: ViewableRouting, animated: Bool = false, insideView targetView: UIView?) {
        let routerVC = viewControllable
        let containerView = targetView ?? routerVC.view!

        routerVC.addChild(router.viewControllable)
        containerView.addSubview(router.viewControllable.view)

        stretchToBounds(holder: containerView, view: router.viewControllable.view)
        if animated {
            router.viewControllable.didMove(toParent: routerVC)
        }
    }

    func removeFromParent() {
        DispatchQueue.main.async {
            self.viewControllable.view.removeFromSuperview()
            self.viewControllable.removeFromParent()
        }
    }

    @available(*, deprecated)
    func pop(animated: Bool) {
        if Thread.isMainThread {
            viewControllable.navigationController?.popViewController(animated: animated)
        } else {
            DispatchQueue.main.async {
                self.viewControllable.navigationController?.popViewController(animated: animated)
            }
        }
    }

    fileprivate func stretchToBounds(holder: UIView, view: UIView) {
        view.layout {
            if #available(iOS 11.0, *) {
                $0.top == holder.safeAreaLayoutGuide.topAnchor
                $0.leading == holder.safeAreaLayoutGuide.leadingAnchor
                $0.bottom == holder.safeAreaLayoutGuide.bottomAnchor
                $0.trailing == holder.safeAreaLayoutGuide.trailingAnchor
            } else {
                $0.top == holder.topAnchor
                $0.leading == holder.leadingAnchor
                $0.bottom == holder.bottomAnchor
                $0.trailing == holder.trailingAnchor
            }
        }
    }
}
