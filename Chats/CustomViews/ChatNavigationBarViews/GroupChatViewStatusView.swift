//
//  GroupChatViewStatusView.swift
//  Chats
//
//  Created by Касилов Георгий on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class GroupChatViewStatusView: ChatNavigationBarView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        groupImageView.cornerRadius = groupImageView.frame.height / 2
    }
    
    //MARK: - Views
    
    private lazy var groupImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
}


//MARK: - Setup Views

extension GroupChatViewStatusView {
    private func setupViews() {
        backgroundColor = UIColor.clear
        containerView = groupImageView
        super.setupSubviews()
    }
    
    public func setup(with groupInfo: ChatListTableViewCellModel) {
        DispatchQueue.main.async {
            self.titleLabelText = groupInfo.collocutorName
            
            if let imageLink = groupInfo.imageLink {
                self.groupImageView.image = UIImage(named: imageLink)
            }
            
            self.statusLabelTextColor = UIColor(named: .steel)
            if let membersCount = groupInfo.membersCount, let membersOnline = groupInfo.membersOnline {
                self.statusLabelText = "\(membersCount.decimalFormatted) members; \(membersOnline) online"
            }
        }
    }
}

