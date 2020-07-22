//
//  ChatScrollDownView.swift
//  Chats
//
//  Created by Касилов Георгий on 22.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class ChatScrollDownView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    private lazy var arrowImageView = UIImageView
        .create {
            $0.image = UIImage(named: "arrowDown")
            $0.contentMode = .scaleAspectFit
    }
    
    private lazy var arrowImageViewContainerView = UIView
        .create {
            $0.backgroundColor = UIColor.blue
            $0.isHidden = true
    }
    
    private lazy var unreadMessagesLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
            $0.textColor = UIColor.white
    }
    
    private lazy var unreadMessagesLabelContainerView = UIView
        .create {
            $0.backgroundColor = UIColor.blue
            $0.isHidden = true
    }
}

// MARK: - Setup Views
extension ChatScrollDownView {
    private func setupViews() {
        borderWidth = 0.5
        borderColor = UIColor.black
        
        addSubview(arrowImageViewContainerView) {
//            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
        
        arrowImageViewContainerView.addSubview(arrowImageView) {
            //            $0.centerX == centerXAnchor
            //            $0.centerY == centerYAnchor
            $0.top == arrowImageViewContainerView.topAnchor + 5
            $0.bottom == arrowImageViewContainerView.bottomAnchor - 5
            $0.leading == arrowImageViewContainerView.leadingAnchor + 5
            $0.trailing == arrowImageViewContainerView.trailingAnchor - 5
            $0.size([\.all: 30])
        }
        
        unreadMessagesLabelContainerView.addSubview(unreadMessagesLabel) {
            $0.centerX == unreadMessagesLabelContainerView.centerXAnchor
            $0.centerY == unreadMessagesLabelContainerView.centerYAnchor
            $0.top == unreadMessagesLabelContainerView.topAnchor + 5
            $0.bottom == unreadMessagesLabelContainerView.bottomAnchor - 5
            $0.leading == unreadMessagesLabelContainerView.leadingAnchor + 5
            $0.trailing == unreadMessagesLabelContainerView.trailingAnchor - 5
        }
        
        addSubview(unreadMessagesLabelContainerView) {
//            $0.top == topAnchor
            $0.centerX == centerXAnchor
            $0.centerY == arrowImageViewContainerView.topAnchor
//            $0.centerY == arrowImageViewContainerView.topAnchor
        }
    }
}
