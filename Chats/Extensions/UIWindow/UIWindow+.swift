//
//  UIWindow+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

private extension UIWindow {
    func reload() {
        subviews.forEach {
            $0.removeFromSuperview()
            addSubview($0)
        }
    }
}

extension Array where Element == UIWindow {
    func reload() {
        forEach {
            $0.reload()
        }
    }
}
