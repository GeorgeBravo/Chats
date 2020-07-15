//
//  UIFont+Extensions.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

enum FontStyle: String {
    case ulraLight = "HelveticaNeue-UltraLight"
    case thin = "HelveticaNeue-Thin"
    case light = "HelveticaNeue-Light"
    case regular = "HelveticaNeue"
    case medium = "HelveticaNeue-Medium"
    case bold = "HelveticaNeue-Bold"
}

extension UIFont {
    class func helveticaNeueFontOfSize(size: CGFloat, style: FontStyle) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
