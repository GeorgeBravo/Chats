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
    
    public lazy var containerView = UIView
        .create { _ in }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.darkText
        label.numberOfLines = 1

        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1

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
        addSubview(containerView) {
            $0.leading == leadingAnchor
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.width == containerView.heightAnchor
        }

        addSubview(stackView) {
            $0.leading == containerView.trailingAnchor + 8
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.trailing == trailingAnchor
        }
    }
}
