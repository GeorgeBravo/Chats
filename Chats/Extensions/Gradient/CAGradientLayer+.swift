//
//  CAGradientLayer+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    enum Point {
        case top, topLeft, topRight
        case bottom, bottomLeft, bottomRight
        case left, right
        case custom(point: CGPoint)

        var point: CGPoint {
            switch self {
            case .top: return [\.x: 0.5]
            case .topLeft: return .zero
            case .topRight: return [\.x: 1]
            case .bottom: return [\.x: 0.5, \.y: 1]
            case .bottomLeft: return [\.y: 1]
            case .bottomRight: return [\.x: 1, \.y: 1]
            case .left: return [\.y: 0.5]
            case .right: return [\.x: 1, \.y: 0.5]
            case let .custom(point): return point
            }
        }
    }

    var gradientImage: UIImage? {
        defer { UIGraphicsEndImageContext() }

        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
}
