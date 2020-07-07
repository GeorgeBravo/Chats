//
//  EditButtonSettupable.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

protocol EditButtonSettupable: class {
    func setupEditButton(target: Any?, action: Selector)
}

extension EditButtonSettupable where Self: UIViewController {
    
    func setupEditButton(target: Any?, action: Selector) {
        self.navigationItem.rightBarButtonItem = nil
        
        let button = UIButton(type: .custom)

        button.setTitle("Edit", for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitleColor(UIColor.labelColor, for: .normal)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
}
