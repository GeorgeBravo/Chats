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

    private lazy var initialsLabel = UILabel
        .create {
            $0.textColor = UIColor.black
            $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
            $0.textAlignment = .left
    }
    
    private lazy var phoneNumberLabel = UILabel
        .create {
            $0.textColor = UIColor.lightGray
            $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
            $0.textAlignment = .left
    }
    
    private lazy var contactImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        phoneNumberLabel.text = ""
        initialsLabel.text = ""
    }
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewContactCellModel else { return }
        contactImageView.image = model.contact.thumbnail
        model.contact.phones.forEach {
            phoneNumberLabel.text?.append(contentsOf: $0.number)
        }
        initialsLabel.text = model.contact.initials
    }
}

// MARK: - Setup Views
extension ContactMessageCell {
    private func setupViews() {
        super.setupSubviews()
        selectionStyle = .none
        
        messageContainerView.addSubview(contactImageView) {
            $0.top == messageContainerView.topAnchor + 8
            $0.bottom == messageContainerView.bottomAnchor - 8
            $0.leading == messageContainerView.leadingAnchor + 8
            $0.size([\.all: 50])
        }
        
        messageContainerView.addSubview(initialsLabel) {
            $0.top == messageContainerView.topAnchor + 10
            $0.leading == contactImageView.trailingAnchor + 10
            $0.trailing == messageContainerView.trailingAnchor - 10
            $0.width == UIScreen.main.bounds.width * 0.3
        }
        
        messageContainerView.addSubview(phoneNumberLabel) {
            $0.top == initialsLabel.bottomAnchor + 1
            $0.leading == initialsLabel.trailingAnchor + 10
            $0.trailing == messageContainerView.trailingAnchor - 10
        }
    }
}
