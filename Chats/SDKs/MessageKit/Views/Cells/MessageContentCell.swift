//
//  MessageContentCell.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

public class MessageContentCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Views
    
    /// The image view displaying the avatar.
    open var avatarView = AvatarView()

    public lazy var messagesContainerView: UIView = {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 1
        return containerView
    }()

    private var messageTimestampLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var readMessageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doubleCheck")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    public lazy var readMessageImageContainerView: UIView = UIView()
    
    private lazy var smileyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "smiley")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageTimestampLabel, readMessageImageContainerView])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        
        return stackView
    }()
    
    private var isFromCurrentSender = false
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    

    open override func prepareForReuse() {
//        accessoryView.removeFromSuperview()
        super.prepareForReuse()

//        messageTimestampLabel.text = nil
//        trailingConstraint?.isActive = false
//        leadingConstraint?.isActive = false
    }


    func someFunc() {

            
    //        self.isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
            
            if isFromCurrentSender {
                
                trailingConstraint = messagesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
                trailingConstraint?.isActive = true
            } else {
                leadingConstraint = messagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
                leadingConstraint?.isActive = true
                
                messagesContainerView.addSubview(smileyImageView) {
                    $0.size([\.all: 20])
                    $0.leading == messagesContainerView.trailingAnchor + 10
                    $0.top == messagesContainerView.topAnchor + 5
                }
            }
            
            readMessageImageContainerView.isHidden = !isFromCurrentSender
            messageTimestampLabel.textColor = isFromCurrentSender ? UIColor.white : UIColor.black.withAlphaComponent(0.5)
            
        }
}

//MARK: - Setup views
extension MessageContentCell {
    private func setupSubviews() {
        readMessageImageContainerView.addSubview(readMessageImageView) {
            $0.centerX == readMessageImageContainerView.centerXAnchor
            $0.centerY == readMessageImageContainerView.centerYAnchor
            $0.leading <= readMessageImageContainerView.leadingAnchor
            $0.trailing <= readMessageImageContainerView.trailingAnchor
            $0.top <= readMessageImageContainerView.topAnchor
            $0.bottom <= readMessageImageContainerView.bottomAnchor
            $0.size([\.width: 15])
        }
        
        contentView.addSubview(messagesContainerView) {
            $0.top == contentView.topAnchor + 2
            $0.bottom == contentView.bottomAnchor - 2
        }
        
        messagesContainerView.addSubview(horizontalStackView) {
            $0.bottom == messagesContainerView.bottomAnchor - 5
            $0.trailing == messagesContainerView.trailingAnchor - 10
        }
        
        horizontalStackView.layout {
            $0.height == 8
        }
    }
}

//MARK: - Actions
extension MessageContentCell {
    
}
