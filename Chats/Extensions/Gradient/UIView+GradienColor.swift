//
//  UIView+GradienColor.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientLayerFrom(_ from: UIColor, to: UIColor,
                              startPoint: CAGradientLayer.Point = .top,
                              endPoint: CAGradientLayer.Point = .bottom) {
        let colors = [from, to]
        let gradientLayer = CAGradientLayer(frame: frame, colors: colors, startPoint: startPoint, endPoint: endPoint)
        layer.addSublayer(gradientLayer)
    }
}
