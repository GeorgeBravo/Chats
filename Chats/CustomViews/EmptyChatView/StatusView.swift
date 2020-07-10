//
//  StatusView.swift
//  Chats
//
//  Created by Mykhailo H on 7/10/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

public enum StatusViewStyle {
    case titled
    case subtitled
}

class StatusView: UIView {
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    var logoImage: UIImage? {
        didSet {
            logoImageView.image = logoImage ?? UIImage()
        }
    }

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder ?? ""
        }
    }

    var textAlignment: NSTextAlignment? {
        didSet {
            placeholderLabel.textAlignment = textAlignment ?? .center
        }
    }
    
    var actionButtonTitle: String? {
        didSet {
            setupActionButton()
        }
    }
    
    typealias ActionButtonHandler = () -> Void
    var actionButtonHandler: ActionButtonHandler?

    fileprivate var style: StatusViewStyle = .titled
    

    init(logo: UIImage? = nil, title: String? = nil, placeholder: String? = nil, buttonTitle: String? = nil, textAlignment: NSTextAlignment? = nil, placeholderAlignment: NSTextAlignment? = nil, style: StatusViewStyle) {
        self.style = style
        self.logoImage = logo
        self.titleText = title
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }

    // MARK: - Setup views

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = placeholder ?? ""
        label.textColor = UIColor.lightGray
        label.font = UIFont.helveticaNeueFontOfSize(size: 20, style: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textColor = UIColor.black
        label.font = UIFont.helveticaNeueFontOfSize(size: 20, style: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    private lazy var logoImageView: UIImageView = {
        let image = logoImage ?? UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle(actionButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        return button
    }()

    fileprivate func setupViews() {
        addSubview(logoImageView)
        addSubview(placeholderLabel)
        addSubview(titleLabel)
    }

    fileprivate func updateViews() {
        logoImageView.layout {
            $0.centerX == centerXAnchor
            $0.top == topAnchor + frame.size.height / 5
            $0.width == widthAnchor
            $0.height == logoImageView.heightAnchor
        }

        switch style {
        case .titled:
            titleLabel.layout {
                $0.centerX == titleLabel.centerXAnchor
                $0.leading == leadingAnchor + 40
                $0.trailing == trailingAnchor - 40
                $0.top == logoImageView.bottomAnchor + 15
            }
        case .subtitled:
            titleLabel.layout {
                $0.centerX == logoImageView.centerXAnchor
                $0.leading == leadingAnchor + 40
                $0.trailing == trailingAnchor - 40
                $0.top == logoImageView.bottomAnchor + 15
            }

            placeholderLabel.layout {
                $0.centerX == titleLabel.centerXAnchor
                $0.leading == leadingAnchor + 40
                $0.trailing == trailingAnchor - 40
                $0.top == titleLabel.bottomAnchor + 15
            }
        }
        
        titleLabel.textColor = style == .titled ? UIColor.lightGray : UIColor.black
        titleLabel.font = style == .titled ? UIFont.helveticaNeueFontOfSize(size: 17, style: .medium) : UIFont.helveticaNeueFontOfSize(size: 20, style: .medium)
    }
    
    private func setupActionButton() {
        if actionButtonTitle != nil {
            addSubview(actionButton) {
                $0.bottom == bottomAnchor - 20
                $0.leading == leadingAnchor + 30
                $0.trailing == trailingAnchor - 30
                $0.height == 48
            }
        }
    }
    
    // MARK: - Actions

    @objc private func actionButtonTapped() {
        actionButtonHandler?()
    }
}
