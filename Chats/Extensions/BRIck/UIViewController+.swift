//
//  UIViewController+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate var navController: UINavigationController? {
        var result: UINavigationController?
        if let navigationController = navigationController {
            result = navigationController
        } else if let parent = parent,
            let navigationController = parent.navigationController {
            result = navigationController
        }
        return result
    }

    func embedInNavigationController() -> UINavigationController {
        if let navController = self.navController {
            return navController
        } else {
            return UINavigationController(rootViewController: self)
        }
    }
}
