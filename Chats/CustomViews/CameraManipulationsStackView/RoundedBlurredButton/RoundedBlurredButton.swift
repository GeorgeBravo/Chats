//
//  RoundedBlurredButton.swift
//  Chats
//
//  Created by user on 19.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let textSize: CGFloat = 16.0
}

class RoundedBlurredButton: UIButton {
    
    // MARK: - Variables
    private var blurView = UIVisualEffectView()
    
    // MARK: - Init
    init(frame: CGRect, blurStyle: UIBlurEffect.Style = .dark) {
        super.init(frame: frame)
        clipsToBounds = true
        setupButton(with: blurStyle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Logic
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.height / 2
        blurView.cornerRadius = bounds.height / 2
        
        if let imageView = imageView { bringSubviewToFront(imageView) }
    }
    
    // MARK: - Setup Logic
    func setupButton(with blurStyle: UIBlurEffect.Style) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.85
        addSubview(blurView) {
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
        setTitle("", for: .normal)
        titleLabel?.font = UIFont.helveticaNeueFontOfSize(size: Constants.textSize, style: .bold)
    }
}
