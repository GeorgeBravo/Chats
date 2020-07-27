//
//  UIAlertController+Extension.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert(viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        actions.forEach { alert.addAction($0) }
        DispatchQueue.main.async {
            UIApplication.topViewController(viewController)?.present(alert, animated: true, completion: nil)
        }
    }
    
//    static func showErrorAlert(message: String?) {
//        let okAction = UIAlertAction(
//            title: LocalizationKeys.ok.localized(),
//            style: .default,
//            handler: nil
//        )
//        DispatchQueue.main.async {
//            UIAlertController.showAlert(title: LocalizationKeys.error.localized(),
//                                        message: message,
//                                        actions: [okAction])
//        }
//    }
}
