//
//  CircleProgressButton.swift
//  Chats
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

struct CircleProgressButtonSettings {
    var borderWidth: CGFloat = 0.0
    var backGroundColor: UIColor = .black
    var progressColor: UIColor = .black
    var baseImageName: String = ""
    var fullProgressImageName: String = ""
}

@IBDesignable
class CircleProgressButton: UIView {
    var fullProgress: Bool = false
    var settings: CircleProgressButtonSettings {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            updateAsset()
        }
    }
    
    var currentImageName: String = "" {
        didSet {
            if currentImageName != oldValue {
                actionButton.setImage(UIImage(named: currentImageName), for: .normal)
            }
        }
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(named: self.settings.baseImageName), for: .normal)

        return button
    }()
    
    private func setupActionButton() {
        addSubview(actionButton) {
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
            $0.width == widthAnchor - settings.borderWidth * 2
            $0.height == heightAnchor - settings.borderWidth * 2
        }
    }

    private var progressLayer = CAShapeLayer()
    
    init(settings: CircleProgressButtonSettings) {
        self.settings = settings
        super.init(frame: .zero)
        setupLayers()
        setupActionButton()
        actionButton.bringSubviewToFront(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.circleCorner = true
    }

    private func setupLayers() {
        progressLayer.lineWidth = settings.borderWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0, 0, -1)
        actionButton.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi / 2), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        backgroundColor = settings.backGroundColor.withAlphaComponent(progress)
        
        let progressCirclePath = UIBezierPath(arcCenter:CGPoint(x: frame.width / 2, y: self.frame.width / 2), radius:self.frame.width / 2 - (settings.borderWidth / 2), startAngle: CGFloat(Double.pi) * -progress, endAngle:CGFloat(Double.pi) * progress, clockwise: true)

        progressLayer.path = progressCirclePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 1
        progressLayer.strokeColor = settings.progressColor.cgColor
    }
    
    private func updateAsset() {
        fullProgress = progress > 1.0
        currentImageName = fullProgress ? settings.fullProgressImageName : settings.baseImageName
    }
}
