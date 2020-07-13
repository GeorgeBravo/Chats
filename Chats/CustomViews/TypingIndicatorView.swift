//
//  TypingIndicatorVIew.swift
//  CometChat
//
//  Created by Marin Benčević on 18/03/2020.
//  Copyright © 2020 marinbenc. All rights reserved.
//

import Foundation
import UIKit

final class TypingIndicatorView: UIView {
    
    /// This view's content size is equal to the main stack.
    override var intrinsicContentSize: CGSize {
        stack.intrinsicContentSize
    }
    
    private enum Constants {
        /// The width of each ellipsis dot.
        static let width: CGFloat = 3
        /// How long should the dot scaling animation last.
        static let scaleDuration: Double = 0.4
        /// How much should the dots scale as a multiplier of their original scale.
        static let scaleAmount: Double = 1.6
        /// How much time should pass between each dot scale animation.
        static let delayBetweenRepeats: Double = 0.9
    }
    
    // MARK: - Views
    
    private lazy var stack = UIStackView
        .create {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 2
    }
    
    private lazy var collocutorImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    private lazy var typingLabel = UILabel
        .create {
            $0.text = "typing"
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textAlignment = .left
            $0.textColor = UIColor.steel
    }
    
    init(frame: CGRect, collocutor: Collocutor) {
        super.init(frame: frame)
        setupViews(with: collocutor)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collocutorImageView.cornerRadius = collocutorImageView.frame.width / 2
    }
    
    func makeDot(animationDelay: Double) -> UIView {
        let view = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(width: Constants.width, height: Constants.width)))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
        
        let circle = CAShapeLayer()
        // Create a circular path
        let path = UIBezierPath(
            arcCenter: .zero,
            radius: Constants.width / 2,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true)
        circle.path = path.cgPath
        
        circle.frame = view.bounds
        circle.fillColor = UIColor.gray.cgColor
        
        view.layer.addSublayer(circle)
        
        // Add a scaling animation for each dot
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = Constants.scaleDuration / 2
        animation.toValue = Constants.scaleAmount
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        
        // Add the scaling animation to a group. The groups duration is longer
        // than the duration of the scale animation. This means there will be a
        // delay in scaling between each repeat of the group.
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = Constants.scaleDuration + Constants.delayBetweenRepeats
        animationGroup.repeatCount = .infinity
        // Add a starting delay.
        animationGroup.beginTime = CACurrentMediaTime() + animationDelay
        
        circle.add(animationGroup, forKey: "pulse")
        
        return view
    }
    
    private func makeDots() -> UIView {
        // Create a stack view to hold the dots.
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = 5
        
        stack.heightAnchor.constraint(equalToConstant: Constants.width).isActive = true
        
        let dots = (0..<3).map { i in
            // Delay the start of each subseqent dot scale animation by 0.3 seconds.
            makeDot(animationDelay: Double(i) * 0.3)
        }
        dots.forEach(stack.addArrangedSubview)
        return stack
    }
}

// MARK: - Setup Views
extension TypingIndicatorView {
    private func setupViews(with collocutor: Collocutor) {
        let dots = makeDots()
        collocutorImageView.image = collocutor.collocutorImage
        
        stack.addArrangedSubview(collocutorImageView)
        stack.addArrangedSubview(dots)
        stack.addArrangedSubview(typingLabel)
        
        
        addSubview(collocutorImageView) {
            $0.leading == leadingAnchor + 15
            $0.bottom == bottomAnchor
            $0.top == topAnchor + 10
            $0.height == collocutorImageView.widthAnchor
        }

        addSubview(typingLabel) {
            $0.leading == collocutorImageView.trailingAnchor + 10
            $0.centerY == collocutorImageView.centerYAnchor
        }

        addSubview(dots) {
            $0.leading == typingLabel.trailingAnchor + 5
//            $0.bottom == bottomAnchor
//            $0.top == topAnchor
            $0.centerY == typingLabel.centerYAnchor
        }
        
//        addSubview(stack) {
//            $0.leading == leadingAnchor + 15
//            $0.trailing == trailingAnchor
//            $0.bottom == bottomAnchor
//            $0.top == topAnchor
//        }
    }
}
