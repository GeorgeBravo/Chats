//
//  MessageManipulationView.swift
//  Chats
//
//  Created by user on 17.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let topButtonSpacing: CGFloat = 4.0
    static let horizontalButtonSpacing: CGFloat = 16.0
    static let horizontalLabelSpacing: CGFloat = 8.0
    static let separatorLineHeight: CGFloat = 0.5
    static let fontSize: CGFloat = 20.0
}

protocol MessageManipulationViewDelegate: class {
    func removeMessageManipulationView()
}

class MessageManipulationView: UIView {
    
    // MARK: - Variables
    weak var delegate: MessageManipulationViewDelegate?
    
    // MARK: - UI Variables
    private var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Logic
    
}

// MARK: - UI Appearance
extension MessageManipulationView {
    func setupViews() {
        addSubview(blurView) {
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurView.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Selectors
extension MessageManipulationView {
    @objc func blurViewTapped() {
        delegate?.removeMessageManipulationView()
    }
}
