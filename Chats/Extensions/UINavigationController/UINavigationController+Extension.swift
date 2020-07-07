//
//  UINavigationController+Extension.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setNavigationBarAppearance(_ largeTitle: Bool = false) {
        navigationBar.isHidden = false
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.backgroundColor = UIColor(named: ColorName.navigationBarBackground)
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.compactAppearance = navigationBarAppearance
            navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
//        navigationBar.barTintColor = UIColor(named: ColorName.navigationBarTint)
        navigationBar.prefersLargeTitles = largeTitle
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.tintColor = .white
    }
}
