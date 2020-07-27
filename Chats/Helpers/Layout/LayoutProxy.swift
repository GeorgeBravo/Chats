//
//  LayoutProxy.swift
//  Layout
//
//  Created by Gorilka on 1/15/19.
//  Copyright © 2019 gorilka-team. All rights reserved.
//

import Foundation
import UIKit

public class LayoutProxy {
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)

    public lazy var height = property(with: view.heightAnchor)
    public lazy var width = property(with: view.widthAnchor)

    public lazy var centerX = property(with: view.centerXAnchor)
    public lazy var centerY = property(with: view.centerYAnchor)

    private let view: UIView

    init(view: UIView) {
        self.view = view
    }

    @discardableResult
    public func size(_ size: CGSize) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        let width = self.width == size.width
        let height = self.height == size.height

        return (width, height)
    }

    private func property<A: LayoutAnchor>(with anchor: A) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor)
    }
}
