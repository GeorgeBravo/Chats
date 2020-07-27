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
        
        if navigationItem.leftBarButtonItems == nil {
            navigationItem.leftBarButtonItems = []
        }
        
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: button))
        navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 10, height: (navigationController?.navigationBar.frame.height)!))))
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setupBackButton(with unreadMessages: Int, target: Any?, action: Selector) {
        self.navigationItem.leftBarButtonItem = nil
        
        let backButtonView = UnreadMessagesBackButton()
        backButtonView.isUserInteractionEnabled = true
        backButtonView.unreadMessages = unreadMessages
        
        backButtonView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButtonView)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
