//
//  UINavigationBar+Gradient.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setGradientBackground(from: UIColor, to: UIColor,
                               startPoint: CAGradientLayer.Point = .left,
                               endPoint: CAGradientLayer.Point = .right) {
        var updatedFrame = bounds
        updatedFrame.size.height += frame.origin.y

        let colors = [from, to]
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
        setBackgroundImage(gradientLayer.gradientImage, for: .default)
    }
}
