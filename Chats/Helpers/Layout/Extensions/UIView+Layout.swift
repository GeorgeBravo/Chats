//
//  UIView+Layout.swift
//  Layout
//
//  Created by Gorilka on 1/15/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func layout(using closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }

    func addSubview(_ view: UIView, using closure: (LayoutProxy) -> Void) {
        addSubview(view)
        view.layout(using: closure)
    }
}
