//
//  UnreadMessagesBackButton.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class UnreadMessagesBackButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var unreadMessages: Int? {
        didSet {
            if let unreadMessages = self.unreadMessages {
                unreadMessagesLabel.text = String(unreadMessages)
                unreadMessagesLabelContainerView.isHidden = false
            } else {
                unreadMessagesLabelContainerView.isHidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        unreadMessagesLabelContainerView.cornerRadius = unreadMessagesLabelContainerView.frame.height / 2
//        unreadMessagesLabelContainerView.cornerRadius = 10
    }
    
    //MARK: - Views
    
    private lazy var unreadMessagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButtonImageView = UIImageView
        .create {
            $0.image = UIImage(named: "backBarButton")
            $0.contentMode = .scaleAspectFit
    }
    
    private lazy var unreadMessagesLabelContainerView = UIView
        .create {
            $0.backgroundColor = UIColor(named: .pinkishRedTwo)
    }
    
}

//MARK: - Setup Views

extension UnreadMessagesBackButton {
    private func setupViews() {
        self.backgroundColor = UIColor.white
        
        addSubview(backButtonImageView) {
            $0.leading == leadingAnchor
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.width == 20
        }
        
        addSubview(unreadMessagesLabelContainerView) {
            $0.trailing == trailingAnchor
            $0.centerY == backButtonImageView.topAnchor
            $0.leading == backButtonImageView.centerXAnchor
        }
        
        unreadMessagesLabelContainerView.addSubview(unreadMessagesLabel) {
            $0.centerX == unreadMessagesLabelContainerView.centerXAnchor
            $0.centerY == unreadMessagesLabelContainerView.centerYAnchor
            $0.top == unreadMessagesLabelContainerView.topAnchor + 5
            $0.bottom == unreadMessagesLabelContainerView.bottomAnchor - 5
            $0.leading == unreadMessagesLabelContainerView.leadingAnchor + 6
            $0.trailing == unreadMessagesLabelContainerView.trailingAnchor - 6
        }
    }
}
