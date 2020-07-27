//
//  GradientCircleView.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class GradientCircleView: UIView {
    typealias GradientCircleViewActionHandler = () -> Void
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCustomViewRounded {
            guard let customView = customView else { return }
            customView.layer.cornerRadius = customView.frame.size.width / 2
        }
    }
    
    @objc enum ResizingBehavior: Int {
        case aspectFit
        case aspectFill
        case stretch
        case center

        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == .zero {
                return rect
            }

            var scales: CGSize = .zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {

            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch: break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2

            return result
        }
    }

    var customView: UIView? = nil {
        didSet {
            updateCustomView()
        }
    }

    var isCustomViewRounded: Bool = true {
        didSet {
            updateCustomView()
        }
    }

    var margin: CGFloat = 0 {
        didSet {
            updateCustomView()
        }
    }

    var resizeBehavior: ResizingBehavior = .stretch {
        didSet{
            updateView()
        }
    }

    var colors: [CGColor] = [] {
        didSet{
            updateView()
        }
    }

    var lineWidth: CGFloat = 3 {
        didSet {
            updateView()
        }
    }

    var isEnabled: Bool = true

    override func draw(_ rect: CGRect) {
        updateView()
    }

    fileprivate var actionHandler: GradientCircleViewActionHandler?

    func addAction(_ action: @escaping GradientCircleViewActionHandler) {

        actionHandler = action

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func tapAction() {
        if isEnabled {
            actionHandler?()
        }
    }

    fileprivate func updateView() {
        drawCircle(frame: bounds, colors: colors, lineWidth: lineWidth, resizing: resizeBehavior)
    }

    fileprivate func updateCustomView() {
        updateView()
        guard let customView = customView else {
            return
        }

        let customSize: CGSize = CGSize(width: bounds.width - lineWidth * 2 - margin * 2, height: bounds.height - lineWidth * 2 - margin * 2)

        customView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customView) {
            $0.leading == leadingAnchor + 4
            $0.trailing == trailingAnchor - 4
            $0.top == topAnchor + 4
            $0.bottom == bottomAnchor - 4
        }

//        let widthConstraint = NSLayoutConstraint(item: customView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: customSize.width)
//        let heightConstraint = NSLayoutConstraint(item: customView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: customSize.height)
//        let centerXConstraint = NSLayoutConstraint(item: customView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
//        let centerYConstraint = NSLayoutConstraint(item: customView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

//        let constraints = [widthConstraint, heightConstraint, centerXConstraint, centerYConstraint]
//
//        addConstraints(constraints)

//        if isCustomViewRounded {
//            customView.layer.cornerRadius = customSize.width / 2
//        }
        customView.layer.masksToBounds = true
    }

    fileprivate func drawCircle(frame targetReact: CGRect, colors: [CGColor], lineWidth: CGFloat, resizing: ResizingBehavior) {

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()

        let resizedFrame: CGRect = resizing.apply(rect: bounds, target: targetReact)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / bounds.width, y: resizedFrame.height / bounds.width)

        guard let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: [0, 0.5, 1]) else {
            return
        }

        let width = targetReact.width
        let halfWidth = width * 0.5
        let height = targetReact.height
        let halfHeight = height * 0.5

        let factor: CGFloat = lineWidth * 0.55
        let lessValue: CGFloat = 22385.76 * (height / 100000)
        let greatValue: CGFloat = 77614.24 * (width / 100000)

        let lessInsideValue: CGFloat = lessValue + factor
        let greatInsideValue: CGFloat = greatValue - factor

        let bezierPath = UIBezierPath()

        bezierPath.move(to: CGPoint(x: width, y: halfHeight))
        bezierPath.addCurve(to: CGPoint(x: halfWidth, y: height), controlPoint1: CGPoint(x: width, y: greatValue), controlPoint2: CGPoint(x: greatValue, y: height))
        
        bezierPath.addCurve(to: CGPoint(x: 0, y: halfHeight), controlPoint1: CGPoint(x: lessValue, y: height), controlPoint2: CGPoint(x: 0, y: greatValue))
        bezierPath.addCurve(to: CGPoint(x: halfWidth, y: 0), controlPoint1: CGPoint(x: 0, y: lessValue), controlPoint2: CGPoint(x: lessValue, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width, y: halfHeight), controlPoint1: CGPoint(x: greatValue, y: 0), controlPoint2: CGPoint(x: width, y: lessValue))
        bezierPath.close()

        bezierPath.move(to: CGPoint(x: width - lineWidth, y: halfHeight))
        bezierPath.addCurve(to: CGPoint(x: halfWidth, y: lineWidth), controlPoint1: CGPoint(x: width - lineWidth, y: lessInsideValue), controlPoint2: CGPoint(x: greatInsideValue, y: lineWidth))
        bezierPath.addCurve(to: CGPoint(x: lineWidth, y: halfHeight), controlPoint1: CGPoint(x: lessInsideValue, y: lineWidth), controlPoint2: CGPoint(x: lineWidth, y: lessInsideValue))
        bezierPath.addCurve(to: CGPoint(x: halfWidth, y: height - lineWidth), controlPoint1: CGPoint(x: lineWidth, y: greatInsideValue), controlPoint2: CGPoint(x: lessInsideValue, y: height - lineWidth))
        bezierPath.addCurve(to: CGPoint(x: width - lineWidth, y: halfHeight), controlPoint1: CGPoint(x: greatInsideValue, y: height - lineWidth), controlPoint2: CGPoint(x: width - lineWidth, y: greatInsideValue))
        bezierPath.addLine(to: CGPoint(x: width, y: halfHeight))
        bezierPath.close()

        context.saveGState()

        bezierPath.addClip()

        context.drawLinearGradient(gradient, start: CGPoint(x: halfWidth, y: 0), end: CGPoint(x: halfWidth, y: height), options: [])
//        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: halfHeight), end: CGPoint(x: width, y: halfHeight), options: [])
        context.restoreGState()

        layer.masksToBounds = true
        layer.cornerRadius = halfWidth
    }
}
