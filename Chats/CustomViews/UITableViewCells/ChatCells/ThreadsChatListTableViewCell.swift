//
//  ThreadsChatListTableViewCell.swift
//  Chats
//
//  Created by Mykhailo H on 8/20/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import Foundation

class ThreadsChatListTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    var leadingUserAvatarConstraint: NSLayoutConstraint?
    var countViewWidthConstraint: NSLayoutConstraint?
    var chatId: Int?
    var chatSelected: Bool?
    
    //MARK: - Views
    private lazy var mainView = UIView.create()
    
    private(set) lazy var avatarView = AvatarView.create {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private(set) lazy var userName = UILabel.create {
        $0.font = UIFont.helveticaNeueFontOfSize(size: 16.7, style: .medium)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: ColorName.optionsBlackColor)
    }
    
    private lazy var timeSent = UILabel.create {
        $0.font =  UIFont.helveticaNeueFontOfSize(size: 13.3, style: .regular)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: ColorName.slateGrey)
    }
    
    private lazy var messageLabel = UILabel.create {
        $0.font = UIFont.helveticaNeueFontOfSize(size: 14, style: .regular)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    private lazy var messageCount = UILabel.create {
        $0.font = UIFont.helveticaNeueFontOfSize(size: 12.7, style: .medium)
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(named: ColorName.coolGreyTwo)
        $0.textColor = UIColor.white
    }
    
    private lazy var lastActivityLabel = UILabel.create {
        $0.font = UIFont.helveticaNeueFontOfSize(size: 12, style: .regular)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: ColorName.warmGrey)
    }
    
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    //MARK: - Private Funcs
    private func changeCountView(count: Int) {
        if count <= 9 && count > 0 {
            messageCount.text = String(count)
            countViewWidthConstraint?.constant = 21.7
            messageCount.backgroundColor = UIColor(named: ColorName.coolGreyTwo)
        }
        if count >= 10 && count <= 99 {
            messageCount.text = String(count)
            countViewWidthConstraint?.constant = 31.7
            messageCount.backgroundColor = UIColor(named: ColorName.aquamarine)
        }
        if count == 0 {
            messageCount.text = ""
            countViewWidthConstraint?.constant = 0
            messageCount.backgroundColor = UIColor.clear
        }
    }
    
    private func setupGroupChatMessage(lastSender: String, message: String) {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = UIColor.black
        attributes[.font] = UIFont.helveticaNeueFontOfSize(size: 15.3, style: .regular)
        let attributedString = NSAttributedString(string: lastSender + ": ", attributes: attributes)
        attributes[.foregroundColor] = UIColor.black
        let attributedStringTwo = NSAttributedString(string: message, attributes: attributes)
        messageLabel.text = nil
        messageLabel.attributedText = attributedString + attributedStringTwo
    }
    
    // MARK: - UI
    
    private func setupViews() {
        selectionColor = .clear
        
        self.contentView.addSubview(mainView) {
            $0.top == contentView.topAnchor + 15
            $0.leading == contentView.leadingAnchor
            $0.bottom == contentView.bottomAnchor
            $0.width == UIScreen.main.bounds.width
        }
                
        mainView.addSubview(avatarView) {
            $0.centerY == mainView.centerYAnchor
            $0.leading == mainView.leadingAnchor + 20
            $0.width == 70
            $0.height == 70
        }
        
        mainView.addSubview(timeSent) {
            $0.top == mainView.topAnchor + 16.5
            $0.trailing == contentView.trailingAnchor - 20
            $0.height == 10
            $0.width == 60
        }
        
        mainView.addSubview(userName) {
            $0.top == mainView.topAnchor + 13
            $0.leading == avatarView.trailingAnchor + 13.3
            $0.trailing <= timeSent.leadingAnchor + 10
            $0.height == 20
        }
        
        mainView.addSubview(messageCount) {
            $0.top == timeSent.bottomAnchor + 5
            $0.trailing == contentView.trailingAnchor - 20
            $0.height == 21.7
            countViewWidthConstraint = $0.width == 21.7
            
        }
        
        mainView.addSubview(messageLabel) {
            $0.top == userName.bottomAnchor
            $0.leading == avatarView.trailingAnchor + 13.3
            $0.trailing == timeSent.leadingAnchor - 10
        }
        
        mainView.addSubview(lastActivityLabel) {
            $0.top == messageLabel.bottomAnchor + 2
            $0.leading == avatarView.trailingAnchor + 13.3
            $0.height == 14
            $0.bottom == mainView.bottomAnchor - 10
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? ThreadsChatListTableViewCellModel else { return }
        
        if let collocutorName = model.collocutorName {
            userName.text = collocutorName
        }
        
        let isGroupChat = model.isGroupChat ?? false
        if isGroupChat {
            let groupModel = GroupAvatarModel(topImage: "roflan", bottomImage: "Dan-Leonard", isOnline: model.isOnline ?? false)
            avatarView.setupView(model: groupModel)
        } else {
            let userModel = UserAvatarModel(image: model.imageLink ?? "roflan", hasStory: model.hasStory ?? false, isOnline: model.isOnline ?? false)
            avatarView.setupView(model: userModel)
        }
            
        if let isSelected = model.isSelected {
            chatSelected = isSelected
        }
        if let groupChat = model.isGroupChat, let  message = model.message , let sender = model.lastSender {
            if groupChat == true {
                setupGroupChatMessage(lastSender: sender, message: message)
            }
        } else {
            if let message = model.message {
                messageLabel.text = message
            }
        }
        
        timeSent.text = model.timeText() ?? model.timeSent ?? " "
        timeSent.textColor = UIColor(named: model.isWeekendDate() ? .pinkishRedTwo : .slateGrey)
        lastActivityLabel.text = "Active 3h ago"
        if let messCount = model.messageCount {
            changeCountView(count: messCount)
        }
        if let id = model.id {
            chatId = id
        }
    }
}

class RadialCircleView: UIView {
    override func draw(_ rect: CGRect) {
        let thickness: CGFloat = 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - thickness / 2
        var last: CGFloat = 0
        for a in 1...360 {
            let ang = CGFloat(a) / 180 * .pi
            let arc = UIBezierPath(arcCenter: center, radius: radius, startAngle: last, endAngle: ang, clockwise: true)
            arc.lineWidth = thickness
            last = ang
            UIColor(hue: CGFloat(a) / 360, saturation: 1, brightness: 1, alpha: 1).set()
            arc.stroke()
        }
    }
}
