//
//  UserChatEntryTableViewCell.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class UserChatEntryTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelContainerView.cornerRadius = titleLabelContainerView.frame.height / 2
    }
    
    // MARK: - Views
    
    fileprivate lazy var titleLabel = UILabel
        .create {
            $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
            $0.textColor = UIColor.white
    }
    
    fileprivate lazy var titleLabelContainerView = UIView
        .create {
            $0.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
}

// MARK: - Setup Views
extension UserChatEntryTableViewCell: TableViewCellSetup {
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(titleLabelContainerView) {
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
        }
        
        titleLabelContainerView.addSubview(titleLabel) {
            $0.centerX == titleLabelContainerView.centerXAnchor
            $0.centerY == titleLabelContainerView.centerYAnchor
            $0.leading == titleLabelContainerView.leadingAnchor + 5
            $0.trailing == titleLabelContainerView.trailingAnchor - 5
            $0.top == titleLabelContainerView.topAnchor + 5
            $0.bottom == titleLabelContainerView.bottomAnchor - 5
        }
    }
    
    func setup(with viewModel: TableViewCellModel) {
        guard let model = viewModel as? UserChatEntryTableViewCellModel else { return }
        
        let userInviteModel = model.userInviteModel
        
        if let inviter = userInviteModel.inviterUserName {
            titleLabel.text = "\(inviter) added \(userInviteModel.inviteeUserName)"
        } else {
            let attributedInviteeString = userInviteModel.inviteeUserName.withAttributes([
                .font: UIFont.helveticaNeueFontOfSize(size: 12, style: .bold),
                .foregroundColor: UIColor.white
            ])
            
            let sampleAttString = " joined the group".withAttributes([
                .font: UIFont.helveticaNeueFontOfSize(size: 12, style: .regular),
                .foregroundColor: UIColor.white
            ])

            titleLabel.attributedText = attributedInviteeString + sampleAttString
        }
    }
}
