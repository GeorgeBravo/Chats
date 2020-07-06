//
//  LayoutAnchor+Comparable.swift
//  Layout
//
//  Created by Gorilka on 1/15/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

public func + <A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

public func - <A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

@discardableResult
public func == <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func == <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.equal(to: rhs)
}

@discardableResult
public func == <A>(lhs: LayoutProperty<A>, rhs: CGFloat) -> NSLayoutConstraint where A: NSLayoutDimension {
    return lhs.equal(toConstant: rhs)
}

@discardableResult
public func >= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.greatThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func >= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.greatThanOrEqual(to: rhs)
}

@discardableResult
public func >= <A>(lhs: LayoutProperty<A>, rhs: CGFloat) -> NSLayoutConstraint where A: NSLayoutDimension {
    return lhs.greatThanOrEqual(toConstant: rhs)
}

@discardableResult
public func <= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: (A, CGFloat)) -> NSLayoutConstraint {
    return lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

@discardableResult
public func <= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) -> NSLayoutConstraint {
    return lhs.lessThanOrEqual(to: rhs)
}

@discardableResult
public func <= <A>(lhs: LayoutProperty<A>, rhs: CGFloat) -> NSLayoutConstraint where A: NSLayoutDimension {
    return lhs.lessThanOrEqual(toConstant: rhs)
}
