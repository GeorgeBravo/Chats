//
//  UIAlertController+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//
import UIKit

typealias AlertActionHandler = (UIAlertAction) -> Void

extension UIAlertController.Style {
    func controller(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: self)
        actions.forEach { controller.addAction($0) }

        return controller
    }
}

extension String {
    func alertAction(style: UIAlertAction.Style = .default, handler: AlertActionHandler? = nil) -> UIAlertAction {
        return UIAlertAction(title: self, style: style, handler: handler)
    }
}
