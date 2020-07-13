//
//  ContactMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class ContactMessageCell: MessageContentCell {
    
    public enum ConstraintsID: String {
        case initialsContainerLeftConstraint
        case disclouserRigtConstraint
    }
    
    /// The view container that holds contact initials
    public lazy var initialsContainerView: UIView = {
        let initialsContainer = UIView(frame: CGRect.zero)
        initialsContainer.backgroundColor = .backgroundColor
        return initialsContainer
    }()
    
    /// The label that display the contact initials
    public lazy var initialsLabel: UILabel = {
        let initialsLabel = UILabel(frame: CGRect.zero)
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = .labelColor
        initialsLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        return initialsLabel
    }()
    
    /// The label that display contact name
    public lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    /// The disclouser image view
    public lazy var disclosureImageView: UIImageView = {
//        let disclouserImage = UIImage.messageKitImageWith(type: .disclouser)?.withRenderingMode(.alwaysTemplate)
//        let disclouser = UIImageView(image: disclouserImage)
        return UIImageView()
    }()
    
    // MARK: - Methods

    private func setupViews() {
        super.setupSubviews()
        messageContainerView.addSubview(initialsContainerView)
        messageContainerView.addSubview(nameLabel)
        messageContainerView.addSubview(disclosureImageView)
        initialsContainerView.addSubview(initialsLabel)
        setupConstraints()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        initialsLabel.text = ""
    }
    
    public func setupConstraints() {
        initialsContainerView.constraint(equalTo: CGSize(width: 26, height: 26))
        let initialsConstraints = initialsContainerView.addConstraints(left: messageContainerView.leftAnchor, centerY: messageContainerView.centerYAnchor,
                                                        leftConstant: 5)
        initialsConstraints.first?.identifier = ConstraintsID.initialsContainerLeftConstraint.rawValue
        initialsContainerView.layer.cornerRadius = 13
        initialsLabel.fillSuperview()
        disclosureImageView.constraint(equalTo: CGSize(width: 20, height: 20))
        let disclosureConstraints = disclosureImageView.addConstraints(right: messageContainerView.rightAnchor, centerY: messageContainerView.centerYAnchor,
                                           rightConstant: -10)
        disclosureConstraints.first?.identifier = ConstraintsID.disclouserRigtConstraint.rawValue
        nameLabel.addConstraints(messageContainerView.topAnchor,
                                 left: initialsContainerView.rightAnchor,
                                 bottom: messageContainerView.bottomAnchor,
                                 right: disclosureImageView.leftAnchor,
                                 topConstant: 0,
                                 leftConstant: 10,
                                 bottomConstant: 0,
                                 rightConstant: 5)
    }
    
    // MARK: - Configure Cell
//    private func dfd () {
//        super.configure(with: message, at: indexPath, and: messagesCollectionView)
//        // setup data
//        guard case let .contact(contactItem) = message.kind else { fatalError("Failed decorate audio cell") }
//        nameLabel.text = contactItem.displayName
//        initialsLabel.text = contactItem.initials
//        // setup constraints
//        guard let dataSource = messagesCollectionView.messagesDataSource else {
//            fatalError(MessageKitError.nilMessagesDataSource)
//        }
//        let initialsContainerLeftConstraint = messageContainerView.constraints.filter { (constraint) -> Bool in
//            return constraint.identifier == ConstraintsID.initialsContainerLeftConstraint.rawValue
//        }.first
//        let disclouserRightConstraint = messageContainerView.constraints.filter { (constraint) -> Bool in
//            return constraint.identifier == ConstraintsID.disclouserRigtConstraint.rawValue
//        }.first
//        if dataSource.isFromCurrentSender(message: message) { // outgoing message
//            initialsContainerLeftConstraint?.constant = 5
//            disclouserRightConstraint?.constant = -10
//        } else { // incoming message
//            initialsContainerLeftConstraint?.constant = 10
//            disclouserRightConstraint?.constant = -5
//        }
//        // setup colors
//        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
//            fatalError(MessageKitError.nilMessagesDisplayDelegate)
//        }
//        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
//        nameLabel.textColor = textColor
//        disclosureImageView.tintColor = textColor
//    }
    
}
