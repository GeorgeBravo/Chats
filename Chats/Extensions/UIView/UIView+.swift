//
//  UIView+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

public extension UIView {
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    var borderWidth: CGFloat? {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue ?? 0
        }
    }

    var cornerRadius: CGFloat? {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue ?? 0
        }
    }
    
    var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}

extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    static func underlayViewCornerRadius() -> CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let topInset = window?.safeAreaInsets.top ?? 0
        return topInset > 20 ? 40 : 5
    }
}
