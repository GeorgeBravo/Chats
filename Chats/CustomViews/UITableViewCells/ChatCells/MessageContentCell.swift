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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Views
    
    public lazy var messageContainerView = UIView
        .create {
            $0.cornerRadius = 18
    }
    
    private lazy var messageTimestampLabel = UILabel
        .create {
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textAlignment = .left
    }
    
    private lazy var editedMessageLabel = UILabel
        .create {
            $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            $0.textAlignment = .left
            $0.text = "edited"
        }
    
    private lazy var readMessageImageView = UIImageView
        .create {
        $0.image = UIImage(named: "doubleCheck")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor.white
        $0.contentMode = .scaleAspectFit

    }
    
    private lazy var readMessageImageContainerView = UIView
        .create { _ in }
    
    public lazy var horizontalStackViewContainerView = UIView
    .create {
        $0.backgroundColor = UIColor.clear
    }
    
    private lazy var messageReactionImageVIew = UIImageView
        .create {
        $0.image = UIImage(named: "smiley")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var profileImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    public lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageTimestampLabel, readMessageImageContainerView])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.red.cgColor
        
        return stackView
    }()
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    public override func prepareForReuse() {
        profileImageView.removeFromSuperview()
        messageReactionImageVIew.removeFromSuperview()
        readMessageImageView.image = nil
        messageTimestampLabel.text = nil
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = false
        super.prepareForReuse()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        horizontalStackViewContainerView.cornerRadius = horizontalStackViewContainerView.frame.height / 2
    }
    
    func setup(with viewModel: TableViewCellModel) {
        switch viewModel {
        case let viewModel as ChatTableViewCellModel:
            readMessageImageContainerView.isHidden = viewModel.isIncomingMessage
            
            messageTimestampLabel.textColor = !viewModel.isIncomingMessage ? UIColor(named: .white50) : UIColor.black.withAlphaComponent(0.5)
            
            editedMessageLabel.textColor = !viewModel.isIncomingMessage ? UIColor(named: .white50) : UIColor.black.withAlphaComponent(0.5)
            
            readMessageImageView.image = viewModel.isMessageRead ? UIImage(named: "doubleCheckmark")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "singleCheckmark")?.withRenderingMode(.alwaysTemplate)
            
            messageTimestampLabel.text = viewModel.timestamp.shortDate
            
            messageContainerView.backgroundColor = viewModel.isIncomingMessage ? UIColor(named: .paleGrey) : UIColor(named: .coolGrey)
            editedMessageLabel.isHidden = !viewModel.isMessageEdited
            
            if !viewModel.isIncomingMessage {
                trailingConstraint = messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
                trailingConstraint?.isActive = true
            } else {
                if let profileImage = viewModel.profileImage {
                    profileImageView.image = profileImage
                    
                    contentView.addSubview(profileImageView) {
                        $0.size([\.all: 30])
                        $0.leading == contentView.leadingAnchor + 10
                        $0.bottom == messageContainerView.bottomAnchor
                    }
                    
                    leadingConstraint = messageContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
                } else {
                    leadingConstraint = messageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
                }
                
                leadingConstraint?.isActive = true
                
                contentView.addSubview(messageReactionImageVIew) {
                    $0.size([\.all: 20])
                    $0.leading == messageContainerView.trailingAnchor + 10
                    $0.top == messageContainerView.topAnchor + 5
                }
            }
        default:
            break
        }
    }
}

//MARK: - Setup views
extension MessageContentCell {
    func setupSubviews() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(messageContainerView) {
            $0.top == contentView.topAnchor + 5
            $0.bottom == contentView.bottomAnchor - 5
        }

        horizontalStackViewContainerView.addSubview(horizontalStackView) {
            $0.centerX == horizontalStackViewContainerView.centerXAnchor
            $0.centerY == horizontalStackViewContainerView.centerYAnchor
            $0.leading == horizontalStackViewContainerView.leadingAnchor + 5
            $0.trailing == horizontalStackViewContainerView.trailingAnchor - 5
            $0.top == horizontalStackViewContainerView.topAnchor + 5
            $0.bottom == horizontalStackViewContainerView.bottomAnchor - 5
            $0.height == 8
        }
        
        messageContainerView.addSubview(horizontalStackViewContainerView) {
            $0.bottom == messageContainerView.bottomAnchor - 7
            $0.trailing == messageContainerView.trailingAnchor - 10
//            $0.height == 8
        }
        
        readMessageImageContainerView.addSubview(readMessageImageView) {
            $0.centerX == readMessageImageContainerView.centerXAnchor
            $0.centerY == readMessageImageContainerView.centerYAnchor
            $0.leading <= readMessageImageContainerView.leadingAnchor
            $0.trailing <= readMessageImageContainerView.trailingAnchor
            $0.top <= readMessageImageContainerView.topAnchor
            $0.bottom <= readMessageImageContainerView.bottomAnchor
            $0.width == 15
        }
    }
}

//MARK: - Actions
extension MessageContentCell {
    
}
