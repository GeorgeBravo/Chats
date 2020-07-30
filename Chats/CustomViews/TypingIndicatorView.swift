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
    
    private enum Constants {
        /// The width of each ellipsis dot.
        static let width: CGFloat = 6.0
        /// How long should the dot scaling animation last.
        static let scaleDuration: Double = 0.4
        /// How much should the dots scale as a multiplier of their original scale.
        static let scaleAmount: Double = 1.6
        /// How much time should pass between each dot scale animation.
        static let delayBetweenRepeats: Double = 0.9
    }
    
    private let chatType: ChatType
    
    init(frame: CGRect, chatType: ChatType) {
        self.chatType = chatType
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    
    private lazy var horizontalStackView = UIStackView
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
            $0.textAlignment = .left
    }
    
    private lazy var dotsContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private var collocutorImageViewLeadingConstraint = NSLayoutConstraint()
    private var typingLabelLeadingConstraint = NSLayoutConstraint()
    private var dotsLeadingConstraint = NSLayoutConstraint()
    private var dotsCustomLeadingConstraint = NSLayoutConstraint()
    private var dotsContainerViewLeadingConstraint = NSLayoutConstraint()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collocutorImageView.cornerRadius = collocutorImageView.frame.width / 2
        dotsContainerView.cornerRadius = dotsContainerView.frame.height / 2
    }
    
    func makeDot(animationDelay: Double) -> UIView {
        let view = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(width: Constants.width, height: Constants.width)))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
        
        let circle = CAShapeLayer()
        // Create a circular path
        let path = UIBezierPath(arcCenter: .zero,
                                radius: Constants.width / 2,
                                startAngle: 0,
                                endAngle: 2 * .pi,
                                clockwise: true)
        circle.path = path.cgPath
        
        circle.frame = view.bounds
        circle.fillColor = UIColor(named: .slateGreyThree).cgColor
        
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
        // Create a horizontalStackView view to hold the dots.
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .bottom
        horizontalStackView.spacing = 6
        
        horizontalStackView.heightAnchor.constraint(equalToConstant: Constants.width).isActive = true
        
        let dots = (0..<3).map { i in
            // Delay the start of each subseqent dot scale animation by 0.3 seconds.
            makeDot(animationDelay: Double(i) * 0.3)
        }
        dots.forEach(horizontalStackView.addArrangedSubview)
        return horizontalStackView
    }
}

// MARK: - Setup Views
extension TypingIndicatorView {
    public func update(with profileImage: UIImage?, typingPeopleCount: Int) {
        collocutorImageView.image = profileImage
        switch chatType {
        case .oneToOne:
            typingLabel.font = UIFont.helveticaNeueFontOfSize(size: 13, style: .regular)
            typingLabel.textColor = UIColor(named: .steel)
            typingLabel.text = "typing"
            collocutorImageView.isHidden = true
            typingLabel.isHidden = true
            
            dotsContainerView.backgroundColor = UIColor(named: .paleGreyTwo)
            dotsContainerViewLeadingConstraint.isActive = true
        case .group:
            dotsContainerView.backgroundColor = .clear
            let peopleCountAttrString = "+\(typingPeopleCount) others".withAttributes([
                .font: UIFont.helveticaNeueFontOfSize(size: 13, style: .medium),
                .foregroundColor: UIColor.black
            ])
            let typingAttrString = " are typing".withAttributes([
                .font: UIFont.helveticaNeueFontOfSize(size: 13, style: .regular),
                .foregroundColor:  UIColor(named: .steel)
            ])
            
            dotsContainerViewLeadingConstraint.isActive = false
            
            typingLabel.attributedText = peopleCountAttrString + typingAttrString
        }
    }
    
    private func setupViews() {
        let dots = makeDots()
        
        horizontalStackView.addArrangedSubview(collocutorImageView)
        horizontalStackView.addArrangedSubview(dots)
        horizontalStackView.addArrangedSubview(typingLabel)
        
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
        
        addSubview(dotsContainerView) {
            $0.bottom == bottomAnchor
            $0.top == topAnchor + 8.0
            $0.leading == typingLabel.trailingAnchor + 6.0
            dotsContainerViewLeadingConstraint = $0.leading == leadingAnchor + 8.0
            dotsContainerViewLeadingConstraint.isActive = false
        }
        
        dotsContainerView.addSubview(dots) {
            $0.leading == dotsContainerView.leadingAnchor + 16.0
            $0.trailing == dotsContainerView.trailingAnchor - 10.0
            $0.centerY == dotsContainerView.centerYAnchor
        }
    }
}
