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
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "roflan")
        imageView.contentMode = .scaleToFill
        imageView.cornerRadius = 33
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var onlineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15.35
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var greenIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9.65
        view.clipsToBounds = true
        view.backgroundColor = .green
        return view
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
    
    private lazy var groupChatTopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "roflan")
        imageView.clipsToBounds = true
        imageView.cornerRadius = 22.35
        return imageView
    }()
    
    private lazy var groupChatBottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Dan-Leonard")
        imageView.clipsToBounds = true
        imageView.cornerRadius = 22.35
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 14, style: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
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
    private lazy var lastActivityLabel = UILabel
        .create {
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
    private func setupGroupChat(isGroup: Bool) {
        if isGroup {
            userAvatar.image = nil
            userAvatar.cornerRadius = 0
            userAvatar.addSubview(groupChatTopImageView) {
                $0.top == userAvatar.topAnchor
                $0.trailing == userAvatar.trailingAnchor
                $0.width == 44.7
                $0.height == 44.7
            }
            
            userAvatar.addSubview(groupChatBottomImageView) {
                $0.bottom == userAvatar.bottomAnchor
                $0.leading == userAvatar.leadingAnchor
                $0.width == 44.7
                $0.height == 44.7
            }
            addOnlineView(isOnline: true)
        } else {
            userAvatar.cornerRadius = 33
            groupChatTopImageView.removeFromSuperview()
            groupChatBottomImageView.removeFromSuperview()
            addOnlineView(isOnline: false)
        }
    }
    
    private func addStoryLayer(hasStory: Bool) {
        if hasStory {
            let radial = GradientView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            radial.backgroundColor = UIColor.clear
            userAvatar.layer.borderColor = UIColor.white.cgColor
            userAvatar.layer.borderWidth = 4
            mainView.addSubview(radial) {
                $0.top == userAvatar.topAnchor - 2
                $0.leading == userAvatar.leadingAnchor - 2
                $0.width == 70
                $0.height == 70
            }
            radial.addCircleGradiendBorder(5)
        } else {
            userAvatar.layer.borderWidth = 0
            userAvatar.layer.borderColor = UIColor.clear.cgColor
            for subview in mainView.subviews {
                if subview.isKind(of: GradientView.self) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    private func addOnlineView(isOnline: Bool) {
        if !isOnline {
            onlineView.removeFromSuperview()
            greenIndicator.removeFromSuperview()
            return
        }
        mainView.addSubview(onlineView) {
            $0.bottom == userAvatar.bottomAnchor + 2
            $0.trailing == userAvatar.trailingAnchor + 5
            $0.width == 30.7
            $0.height == 30.7
        }
        onlineView.addSubview(greenIndicator) {
            $0.centerX ==  onlineView.centerXAnchor
            $0.centerY == onlineView.centerYAnchor
            $0.width == 19.3
            $0.height == 19.3
        }
    }
    private func setupViews() {
        selectionStyle = .none
        
        self.contentView.addSubview(mainView) {
            $0.top == contentView.topAnchor + 15
            $0.leading == contentView.leadingAnchor
            $0.bottom == contentView.bottomAnchor
            $0.width == UIScreen.main.bounds.width
        }
        
        mainView.addSubview(userAvatar) {
            $0.centerY == mainView.centerYAnchor
            $0.leading == mainView.leadingAnchor + 20
            $0.width == 66
            $0.height == 66
        }
        
        mainView.addSubview(timeSent) {
            $0.top == mainView.topAnchor + 16.5
            $0.trailing == contentView.trailingAnchor - 20
            $0.height == 10
            $0.width == 60
        }
        
        mainView.addSubview(userName) {
            $0.top == mainView.topAnchor + 13
            $0.leading == userAvatar.trailingAnchor + 13.3
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
            $0.leading == userAvatar.trailingAnchor + 13.3
            $0.trailing == timeSent.leadingAnchor - 10
        }
        
        mainView.addSubview(lastActivityLabel) {
            $0.top == messageLabel.bottomAnchor + 2
            $0.leading == userAvatar.trailingAnchor + 13.3
            $0.height == 14
            $0.bottom == mainView.bottomAnchor - 10
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? ThreadsChatListTableViewCellModel else { return }
        
        if let collocutorName = model.collocutorName {
            userName.text = collocutorName
        }
        
        if let goupedChat = model.isGroupChat {
            setupGroupChat(isGroup: goupedChat)
        }
        
        if let isOnline = model.isOnline {
            addOnlineView(isOnline: isOnline)
        }
        
        if let hasStory = model.hasStory {
            addStoryLayer(hasStory: hasStory)
        }
            
        if let isSelectedd = model.isSelected {
            chatSelected = isSelectedd
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
        if let image = model.imageLink {
            userAvatar.image = UIImage(named: image)
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
