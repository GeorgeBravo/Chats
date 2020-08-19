//
//  MessageContentCell.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let longPressDuration: TimeInterval = 0.4
    static let sendStatusImageViewWidth: CGFloat = 15.0
    static let horizontalStackViewSpacing: CGFloat = 6.0
    static let horizontalStackViewSideSpacing: CGFloat = 5.0
    static let horizontalStackViewContainerViewTrailing: CGFloat = 10.0
}

public class MessageContentCell: UITableViewCell {
    
    // MARK: - Variables
    private var messageModel: ChatContentTableViewCellModel?
    
    // MARK: - Inits
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Views
    
    public lazy var messageContainerView = UIView
        .create {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.cornerRadius = 0
    }
    
    private lazy var messageTimestampLabel = UILabel
        .create {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.helveticaNeueFontOfSize(size: 11, style: .regular)
            $0.textAlignment = .left
    }
    
    private lazy var editedMessageLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 11, style: .regular)
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
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
    }
    
    private lazy var messageReactionImageView = UIImageView
        .create {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "smiley")
            $0.contentMode = .scaleAspectFit
    }
    
    private lazy var profileImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    public lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageTimestampLabel, readMessageImageContainerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.horizontalStackViewSpacing
        
        return stackView
    }()
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    public override func prepareForReuse() {
        profileImageView.removeFromSuperview()
        messageReactionImageView.removeFromSuperview()
        readMessageImageView.image = nil
        messageTimestampLabel.text = nil
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = false
        horizontalStackViewContainerView.backgroundColor = .clear
        super.prepareForReuse()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        horizontalStackViewContainerView.cornerRadius = horizontalStackViewContainerView.frame.height / 2
        guard let msgModel = messageModel else { return }
        self.contentView.layoutSubviews()
        let corners = msgModel.messageCornerRoundedType.getCorners(isIncomming: msgModel.isIncomingMessage)
        messageContainerView.roundCorners(topLeft: corners.topLeft, topRight: corners.topRight, bottomLeft: corners.bottomLeft, bottomRight: corners.bottomRight)
    }
    
    func setup(with viewModel: TableViewCellModel) {
        
        guard let viewModel = viewModel as? ChatContentTableViewCellModel else { return }
        messageModel = viewModel
        
        if viewModel is ChatTableViewTextMessageCellModel {
            horizontalStackViewContainerView.backgroundColor = UIColor.clear
        }
        
        contentView.isHidden = viewModel.needHideMessage
        
        readMessageImageContainerView.isHidden = viewModel.isIncomingMessage
        
        messageTimestampLabel.textColor = !viewModel.isIncomingMessage ? UIColor(named: .white50) : UIColor.black.withAlphaComponent(0.5)
        
        editedMessageLabel.textColor = !viewModel.isIncomingMessage ? UIColor(named: .white50) : UIColor.black.withAlphaComponent(0.5)
        
        readMessageImageView.image = viewModel.isMessageRead ? UIImage(named: "doubleCheckmark")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "singleCheckmark")?.withRenderingMode(.alwaysTemplate)
        
        messageTimestampLabel.text = viewModel.timestamp.shortDate
        
        messageContainerView.backgroundColor = viewModel.isIncomingMessage ? UIColor(named: .paleGreyTwo) : UIColor(named: .coolGrey)
        editedMessageLabel.isHidden = !viewModel.isMessageEdited
        
        if !viewModel.isIncomingMessage {
            trailingConstraint = messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            trailingConstraint?.isActive = true
        } else {
            if let profileImage = viewModel.profileImage, viewModel.chatType == .group {
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
            
            contentView.addSubview(messageReactionImageView) {
                $0.size([\.all: 20])
                $0.leading == messageContainerView.trailingAnchor + 10
                $0.top == messageContainerView.topAnchor + 2
            }
        }
    }
}

//MARK: - Setup views
extension MessageContentCell {
    func setupSubviews() {
        setupGesture()
        backgroundColor = UIColor.clear
        
        contentView.addSubview(messageContainerView) {
            $0.top == contentView.topAnchor + 2
            $0.bottom == contentView.bottomAnchor - 2
        }
        
        horizontalStackViewContainerView.addSubview(horizontalStackView) {
            $0.centerX == horizontalStackViewContainerView.centerXAnchor
            $0.centerY == horizontalStackViewContainerView.centerYAnchor
            $0.leading == horizontalStackViewContainerView.leadingAnchor + Constants.horizontalStackViewSideSpacing
            $0.trailing == horizontalStackViewContainerView.trailingAnchor - Constants.horizontalStackViewSideSpacing
            $0.top == horizontalStackViewContainerView.topAnchor + Constants.horizontalStackViewSideSpacing
            $0.bottom == horizontalStackViewContainerView.bottomAnchor - Constants.horizontalStackViewSideSpacing
            $0.height == 8
        }
        
        messageContainerView.addSubview(horizontalStackViewContainerView) {
            $0.bottom == messageContainerView.bottomAnchor - 4
            $0.trailing == messageContainerView.trailingAnchor - Constants.horizontalStackViewContainerViewTrailing
        }
        
        readMessageImageContainerView.addSubview(readMessageImageView) {
            $0.centerX == readMessageImageContainerView.centerXAnchor
            $0.centerY == readMessageImageContainerView.centerYAnchor
            $0.leading <= readMessageImageContainerView.leadingAnchor
            $0.trailing <= readMessageImageContainerView.trailingAnchor
            $0.top <= readMessageImageContainerView.topAnchor
            $0.bottom <= readMessageImageContainerView.bottomAnchor
            $0.width == Constants.sendStatusImageViewWidth
        }
    }
    
    private func setupGesture() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGestureRecognizer.minimumPressDuration = Constants.longPressDuration
        addGestureRecognizer(longPressGestureRecognizer)
    }
}

//MARK: - Actions
extension MessageContentCell {
    @objc
    private func longPress(_ gesture: UIGestureRecognizer) {
        guard gesture.state == .began else { return }
        guard let cellNewFrame = superview?.convert(frame, to: nil) else { return }
        messageModel?.messageSelected(cellNewFrame: cellNewFrame)
    }
}

extension MessageContentCell {
    func countHorizontalStackViewContainerViewSize(model: ChatTableViewTextMessageCellModel) -> CGSize {
        let height: CGFloat = 8 + Constants.horizontalStackViewSideSpacing * 2
        var width: CGFloat = model.timestamp.shortDate.sizeOfString(usingFont: messageTimestampLabel.font).width
        if !model.isIncomingMessage {
            width += Constants.horizontalStackViewSpacing
            width += Constants.sendStatusImageViewWidth
        }
        width += Constants.horizontalStackViewSideSpacing * 2
        return CGSize(width: width, height: height)
    }
    
    func countHorizontalContainerSideSpacings() -> CGFloat {
        return Constants.horizontalStackViewSideSpacing * 2
    }
    
    func horizontalViewTrailingValue() -> CGFloat {
        return Constants.horizontalStackViewContainerViewTrailing
    }
}
