//
//  LayoutProperty.swift
//  Layout
//
//  Created by Gorilka on 1/15/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

public struct LayoutProperty<Anchor: LayoutAnchor> {
    let anchor: Anchor
}

extension LayoutProperty {
    @discardableResult
    func equal(to other: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: other, constant: constant)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func greatThanOrEqual(to other: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: other, constant: constant)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func lessThanOrEqual(to other: Anchor, offsetBy constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: other, constant: constant)
        constraint.isActive = true

        return constraint
    }
}

extension LayoutProperty where Anchor: NSLayoutDimension {
    @discardableResult
    func equal(toConstant c: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalToConstant: c)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func greatThanOrEqual(toConstant c: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualToConstant: c)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func lessThanOrEqual(toConstant c: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualToConstant: c)
        constraint.isActive = true

        return constraint
    }
}
