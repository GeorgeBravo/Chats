//
//  ChatListTableViewCell.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

protocol ChatListTableViewCellDelegate {
    func checkMarkSelected(chatId: Int)
    func checkMarkUnselected(chatId: Int)
}

class ChatListTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    var leadingUserAvatarConstraint: NSLayoutConstraint?
    var checkButtonWidthConstraint: NSLayoutConstraint?
    var chatId: Int?
    var delegate: ChatListTableViewCellDelegate?
    var chatSelected: Bool?
    
    //MARK: - Views
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "roflan")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 16.7, style: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(named: ColorName.optionsBlackColor)
        return label
    }()
    
    private lazy var timeSent: UILabel = {
        let label = UILabel()
        label.font =  UIFont.helveticaNeueFontOfSize(size: 13.3, style: .regular)
        label.textAlignment = .right
        label.textColor = UIColor(named: ColorName.slateGrey)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 15.3, style: .regular)
        label.textAlignment = .left
        label.textColor = UIColor(named: ColorName.slateGrey)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var messageCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 12.7, style: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = UIColor(named: ColorName.coolGreyTwo)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var checkMarkButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: ColorName.coolGrey).cgColor
        button.addTarget(self, action: #selector(checkMarkTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !editing {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.checkMarkButton.backgroundColor = UIColor.white
                self.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Objc Functions
    @objc func checkMarkTapped() {
        if let id = chatId {
            if checkMarkButton.isSelected {
                checkMarkButton.isSelected = false
                checkMarkButton.backgroundColor = UIColor.white
                delegate?.checkMarkUnselected(chatId: id)
            } else {
                checkMarkButton.isSelected = true
                checkMarkButton.backgroundColor = UIColor.black
                delegate?.checkMarkSelected(chatId: id)
            }
        }
    }
    
    // MARK: - UI
    private func setupViews() {
        selectionStyle = .none
        
        self.contentView.addSubview(mainView) {
            $0.top == contentView.topAnchor
            $0.leading == contentView.leadingAnchor
            $0.bottom == contentView.bottomAnchor
            $0.width == UIScreen.main.bounds.width
        }
        
        mainView.addSubview(userAvatar) {
            $0.top == mainView.topAnchor + 12
            $0.leading == mainView.leadingAnchor + 15.3
            $0.width == 60
            $0.height == 60
        }
        
        addSubview(checkMarkButton) {
            $0.centerY == userAvatar.centerYAnchor
            $0.trailing == userAvatar.leadingAnchor - 16
            $0.width == 30
            $0.height == 30
        }
        
        mainView.addSubview(timeSent) {
            $0.top == mainView.topAnchor + 16.5
            $0.trailing == mainView.trailingAnchor - 21
            $0.height == 10
        }
        
        mainView.addSubview(userName) {
            $0.top == mainView.topAnchor + 13
            $0.leading == userAvatar.trailingAnchor + 13.3
            $0.trailing <= timeSent.leadingAnchor + 10
            $0.height == 20
        }
        
        mainView.addSubview(messageCount) {
            $0.bottom == mainView.bottomAnchor - 10
            $0.trailing == mainView.trailingAnchor - 21
            $0.height == 21.7
            $0.width == 21.7
            
        }
        
        mainView.addSubview(messageLabel) {
            $0.bottom == mainView.bottomAnchor - 10
            $0.top == userName.bottomAnchor
            $0.leading == userAvatar.trailingAnchor + 13.3
            $0.trailing == messageCount.leadingAnchor - 23.7
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? ChatListTableViewCellModel else { return }
        
        if let collocutorName = model.collocutorName {
            userName.text = collocutorName
        }
        if let isSelectedd = model.isSelected {
            chatSelected = isSelectedd
        }
        if let message = model.message {
            messageLabel.text = message
        }
        if let sentTime = model.timeSent {
            timeSent.text = sentTime
        }
        if let messCount = model.messageCount {
            messageCount.text = String(messCount)
        }
        if let id = model.id {
            chatId = id
        }
    }
}
