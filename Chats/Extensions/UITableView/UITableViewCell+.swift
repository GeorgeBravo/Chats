//
//  UITableViewCell+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: self.reusableIdentifier, bundle: nil)
    }

    var selectionColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        set {
            guard selectionStyle != .none else {
                return
            }
            selectedBackgroundView = UIView.create {
                $0.backgroundColor = newValue
            }
        }
    }
}
