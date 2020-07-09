//
//  UINavigationController+Extension.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setNavigationBarAppearance(_ largeTitle: Bool = false, bigFont: Bool = false) {
        navigationBar.isHidden = false
        let font = UIFont.systemFont(ofSize: 24.0, weight: .heavy)
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = UIColor(named: .whiteColor)
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: .optionsBlackColor)]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: .optionsBlackColor)]
            if bigFont {
                navigationBarAppearance.titleTextAttributes = [.font: font, .foregroundColor: UIColor(named: .optionsBlackColor)]
                navigationBarAppearance.largeTitleTextAttributes = [.font: font, .foregroundColor: UIColor(named: .optionsBlackColor)]
            }
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.compactAppearance = navigationBarAppearance
            navigationBar.scrollEdgeAppearance = navigationBarAppearance
        }
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(named: .whiteColor)
        navigationBar.prefersLargeTitles = largeTitle
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: .optionsBlackColor)]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: .optionsBlackColor)]
        navigationBar.tintColor = UIColor(named: .optionsBlackColor)
        if bigFont {
            navigationBar.titleTextAttributes = [.font: font]
        }
    }
}
