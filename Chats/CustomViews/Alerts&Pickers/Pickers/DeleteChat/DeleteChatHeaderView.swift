//
//  DeleteChatHeaderView.swift
//  Chats
//
//  Created by Mykhailo H on 7/29/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class DeleteChatHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properites
    
    var interlocutoreName: String? {
        didSet {
            if !isGroupChat {
                alertLabel.text = String(format: LocalizationKeys.deleteChatWith.localized(), interlocutoreName ?? "interlocutor")
            } else {
                alertLabel.text = String(format: LocalizationKeys.leaveChat.localized(), interlocutoreName ?? "interlocutor")
            }
        }
    }
    var isGroupChat: Bool = false
    
    //MARK: - Views
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.cornerRadius = imageView.width/2
        imageView.image = UIImage(named: "roflan")
        return imageView
    }()
    
    fileprivate lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 15, style: .regular)
        label.textColor = UIColor.darkText
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
}

extension DeleteChatHeaderView {
    func setupViews() {
        backgroundColor = UIColor.clear
        
        addSubview(avatarImageView) {
            $0.centerX == centerXAnchor
            $0.top == topAnchor + 20
            $0.height == 60
            $0.width == 60
        }
        
        addSubview(alertLabel) {
            $0.centerX == centerXAnchor
            $0.top == avatarImageView.bottomAnchor + 10
            $0.width == UIScreen.main.bounds.width * 0.8
            $0.bottom == bottomAnchor
        }
    }
}
