//
//  BackButtonSettupable.swift
//  SmartResident
//
//  Created by Касилов Георгий on 12/26/19.
//  Copyright © 2019 Stream LLC. All rights reserved.
//

import UIKit

protocol BackButtonSettupable: class {
    func setupBackButton(target: Any?, action: Selector)
    func setupBackButton(with unreadMessages: Int, target: Any?, action: Selector)
}

extension BackButtonSettupable where Self: UIViewController {
    func setupBackButton(target: Any?, action: Selector) {
        self.navigationItem.leftBarButtonItem = nil
        
        let button = UIButton(type: .custom)
        let buttonImage = UIImage(named: "backBarButton")

        button.setImage(buttonImage, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setupBackButton(with unreadMessages: Int, target: Any?, action: Selector) {
        self.navigationItem.leftBarButtonItem = nil
        
        let backButtonView = UnreadMessagesBackButton()
        backButtonView.isUserInteractionEnabled = false
        backButtonView.unreadMessages = unreadMessages
        
        let button = UIButton(type: .custom)
        let buttonImage = UIImage(named: "backBarButton")
        
        button.setImage(buttonImage, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        button.addSubview(backButtonView) {
            $0.centerY == button.topAnchor
            $0.height == 20
            $0.leading == button.centerXAnchor
        }
        
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
