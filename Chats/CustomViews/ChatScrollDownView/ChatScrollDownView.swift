//
//  ChatScrollDownView.swift
//  Chats
//
//  Created by Касилов Георгий on 22.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class ChatScrollDownView: UIView {
    public var onArrowDidTap: (() -> Void)?
    
    public var unreadMessageCount: Int = 0 {
        didSet {
            unreadMessageCountDidChange(from: oldValue)
        }
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden { unreadMessageCount = 0 }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrowImageViewContainerView.cornerRadius = arrowImageViewContainerView.frame.height / 2
        unreadMessagesLabelContainerView.cornerRadius = unreadMessagesLabelContainerView.frame.height / 2
    }
    
    // MARK: - Private
    
    private func unreadMessageCountDidChange(from oldValue: Int) {
        guard unreadMessageCount != oldValue else { return }
        
        unreadMessagesLabelContainerView.isHidden = unreadMessageCount == 0
        
        unreadMessagesLabel.text = "\(unreadMessageCount)"
    }
    
    // MARK: - Views
    
    private lazy var arrowImageView = UIImageView
        .create {
            $0.image = UIImage(named: "arrowDown")
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onArrowImageViewDidTap)))
    }
    
    private lazy var arrowImageViewContainerView = UIView
        .create {
            $0.backgroundColor = UIColor(named: ColorName.paleGrey)
            $0.borderWidth = 0.25
            $0.borderColor = UIColor.black
    }
    
    private lazy var unreadMessagesLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
    }
    
    private lazy var unreadMessagesLabelContainerView = UIView
        .create {
            $0.backgroundColor = UIColor(named: .summersky)
            $0.isHidden = true
    }
}

// MARK: - Setup Views
extension ChatScrollDownView {
    private func setupViews() {
        addSubview(arrowImageViewContainerView) {
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
        
        arrowImageViewContainerView.addSubview(arrowImageView) {
            $0.top == arrowImageViewContainerView.topAnchor + 10
            $0.bottom == arrowImageViewContainerView.bottomAnchor - 10
            $0.leading == arrowImageViewContainerView.leadingAnchor + 10
            $0.trailing == arrowImageViewContainerView.trailingAnchor - 10
            $0.size([\.all: 20])
        }
        
        unreadMessagesLabelContainerView.addSubview(unreadMessagesLabel) {
            $0.centerX == unreadMessagesLabelContainerView.centerXAnchor
            $0.centerY == unreadMessagesLabelContainerView.centerYAnchor
            $0.top == unreadMessagesLabelContainerView.topAnchor + 5
            $0.bottom == unreadMessagesLabelContainerView.bottomAnchor - 5
            $0.leading == unreadMessagesLabelContainerView.leadingAnchor + 5
            $0.trailing == unreadMessagesLabelContainerView.trailingAnchor - 5
            $0.width == unreadMessagesLabel.heightAnchor
        }
        
        addSubview(unreadMessagesLabelContainerView) {
            $0.top == topAnchor + 5
            $0.centerX == centerXAnchor
            $0.centerY == arrowImageViewContainerView.topAnchor
        }
    }
}

// MARK: - Actions
extension ChatScrollDownView {
    @objc
    private func onArrowImageViewDidTap() {
        onArrowDidTap?()
    }
}
