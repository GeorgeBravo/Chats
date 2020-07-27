//
//  LayoutAnchor.swift
//  Layout
//
//  Created by Gorilka on 1/15/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}
