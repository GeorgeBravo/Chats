//
//  ViewControllable+AddViewController.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck
// import Layout

protocol ViewControllableAddSubController: class {
    func addViewControllable(_ viewControllable: ViewControllable)
}

extension ViewControllableAddSubController where Self: ViewControllable {
    func addViewControllable(_ viewControllable: ViewControllable) {
        addChild(viewControllable)

        let containerView = view!
        containerView.addSubview(viewControllable.view) {
            $0.top == containerView.safeAreaLayoutGuide.topAnchor
            $0.leading == containerView.leadingAnchor
            $0.bottom == containerView.safeAreaLayoutGuide.bottomAnchor
            $0.trailing == containerView.trailingAnchor
        }
    }
}
