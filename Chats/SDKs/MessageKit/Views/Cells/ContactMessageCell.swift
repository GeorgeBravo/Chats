//
//  ContactMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class ContactMessageCell: MessageContentCell, TableViewCellSetup {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views

    private lazy var displayNameLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 15, style: .medium)
            $0.textAlignment = .left
    }
    
    private lazy var phoneNumberLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 14, style: .regular)
            $0.textAlignment = .left
            $0.numberOfLines = 0
    }
    
    private lazy var contactImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [displayNameLabel, phoneNumberLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2

        return stackView
    }()
    
    public override func prepareForReuse() {
        phoneNumberLabel.text = nil
        displayNameLabel.text = nil
        contactImageView.image = nil
        super.prepareForReuse()
        
    }
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewContactCellModel else { return }

        displayNameLabel.text = model.contact.displayName
        phoneNumberLabel.text = model.contact.phones.map { $0.number }.joined(separator: "\n")
        
        if let thubmnail = model.contact.thumbnail {
            contactImageView.image = thubmnail
        } else {
            contactImageView.setImage(string: model.contact.initials, circular: true)
        }

        phoneNumberLabel.textColor = model.isIncomingMessage ? UIColor.black : UIColor.white
        displayNameLabel.textColor = model.isIncomingMessage ? UIColor.black : UIColor.white
    }
}

// MARK: - Setup Views
extension ContactMessageCell {
    private func setupViews() {
        super.setupSubviews()
        
        selectionStyle = .none
        
        messageContainerView.addSubview(contactImageView) {
            $0.top == messageContainerView.topAnchor + 8
            $0.leading == messageContainerView.leadingAnchor + 8
            $0.size([\.all: 50])
        }
        
        messageContainerView.addSubview(stackView) {
            $0.top == messageContainerView.topAnchor + 10
            $0.bottom == messageContainerView.bottomAnchor - 20
            $0.leading == contactImageView.trailingAnchor + 10
            $0.trailing == messageContainerView.trailingAnchor - 10
            $0.width == UIScreen.main.bounds.width * 0.4
        }
        
//        messageContainerView.addSubview(displayNameLabel) {
//            $0.top == messageContainerView.topAnchor + 10
//            $0.leading == contactImageView.trailingAnchor + 10
//            $0.trailing == messageContainerView.trailingAnchor - 10
//            $0.width == UIScreen.main.bounds.width * 0.4
//        }
//
//        messageContainerView.addSubview(phoneNumberLabel) {
//            $0.top == displayNameLabel.bottomAnchor + 2
//            $0.bottom == messageContainerView.bottomAnchor - 20
//            $0.leading == contactImageView.trailingAnchor + 10
//            $0.trailing == messageContainerView.trailingAnchor - 10
//        }
    }
}
