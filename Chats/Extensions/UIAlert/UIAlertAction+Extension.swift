//
//  UIAlertAction+Extension.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let imageKey: String = "image"
}

extension UIAlertAction {
    private static func action(title: String?, image: UIImage?, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let action = UIAlertAction(
            title: title,
            style: .default,
            handler: handler)
        action.setValue(image, forKey: Constants.imageKey)
        return action
    }
    
    static func okAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction.action(
            title: LocalizationKeys.ok.localized(),
            image: nil,
            handler: handler
        )
    }
    
}
