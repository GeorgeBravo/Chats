//
//  ChatNavigationBarView.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class ChatNavigationBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var titleLabelText: String? {
        didSet {
            titleLabel.text = titleLabelText
        }
    }

    public var statusLabelText: String? {
        didSet {
            statusLabel.text = statusLabelText
        }
    }
    
    public var statusLabelTextColor: UIColor? {
        didSet {
            statusLabel.textColor = statusLabelTextColor
        }
    }
    
    // MARK: - Views
    var spacingConstraint: NSLayoutConstraint?
    public lazy var containerView = UIView
        .create { _ in }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.darkText
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, statusLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2

        return stackView
    }()
}

// MARK: - Setup Views
extension ChatNavigationBarView {
    public func setupSubviews() {
        addSubview(stackView) {
            $0.leading == leadingAnchor
            $0.top == topAnchor
            $0.bottom == bottomAnchor
        }
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751.0), for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 752.0), for: .horizontal)
        stackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 753.0), for: .horizontal)
        containerView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 754.0), for: .horizontal)
        
        addSubview(containerView) {
            spacingConstraint = $0.leading == stackView.trailingAnchor + UIScreen.main.bounds.width
            spacingConstraint?.priority = UILayoutPriority(rawValue: 749)
            $0.leading >= stackView.trailingAnchor + 8.0
            $0.height == heightAnchor
            $0.centerY == centerYAnchor
            $0.trailing == trailingAnchor - 2
            $0.width == heightAnchor
        }
    }
    
}
