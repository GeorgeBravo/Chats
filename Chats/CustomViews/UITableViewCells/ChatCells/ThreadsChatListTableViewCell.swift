//
//  ThreadsChatListTableViewCell.swift
//  Chats
//
//  Created by Mykhailo H on 8/20/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import Foundation

protocol SlidingCellDelegate {
    // tell the TableView that a swipe happened
    func hasPerformedSwipe(touch: CGPoint)
    func hasPerformedTap(touch: CGPoint)
}

class ThreadsChatListTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    var leadingUserAvatarConstraint: NSLayoutConstraint?
    var countViewWidthConstraint: NSLayoutConstraint?
    var deleteViewLeadingContraint: NSLayoutConstraint?
    var chatId: Int?
    var chatSelected: Bool?
    var delegate: SlidingCellDelegate?
    var originalCenter = CGPoint()
    var isSwipeSuccessful = false
    var touch = CGPoint()
    var lastTranslation = CGPoint()
    
    //MARK: - Views
    private lazy var deleteCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.cornerRadius = 22
        return view
    }()
    
    private lazy var shadowAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        animation.toValue = 0.0
        return animation
    }()
    
    private lazy var mainView = UIView.create {
        $0.backgroundColor = .white
    }
    
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
        // add a PAN gesture
        let pRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pRecognizer.delegate = self
        addGestureRecognizer(pRecognizer)
        
        // add a TAP gesture
        // note that adding the PAN gesture to a cell disables the built-in tap responder (didSelectRowAtIndexPath)
        // so we can add in our own here if we want both swipe and tap actions
//        let tRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tRecognizer.delegate = self
//        addGestureRecognizer(tRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            //look for right-swipe
            //            if (fabs(translation.x) > fabs(translation.y)) && (translation.x > 0) {
            
            // look for left-swipe
            if (fabs(translation.x) > fabs(translation.y)) && (translation.x < 0) {
                //print("gesture 1")
                touch = panGestureRecognizer.location(in: superview)
                return true
            }
            //not left or right - must be up or down
            return false
        }else if gestureRecognizer is UITapGestureRecognizer {
            touch = gestureRecognizer.location(in: superview)
            return true
        }
        return false
    }
    
    //MARK: - Private Funcs
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer){
        // call function to get indexPath since didSelectRowAtIndexPath will be disabled
        delegate?.hasPerformedTap(touch: touch)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            originalCenter = center
        }
        
        if recognizer.state == .changed {
            checkIfSwiped(recongizer: recognizer)
        }
        
        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if isSwipeSuccessful{
                delegate?.hasPerformedSwipe(touch: touch)
                
                //after 'short' swipe animate back to origin quickly
                moveViewBackIntoPlaceSlowly(originalFrame: originalFrame)
            } else {
                //after successful swipe animate back to origin slowly
                moveViewBackIntoPlace(originalFrame: originalFrame)
            }
        }
    }
    
    private func checkIfSwiped(recongizer: UIPanGestureRecognizer) {
        let translation = recongizer.translation(in: self)
        center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        print(center.x)
        if lastTranslation.x != 0 {
             deleteViewLeadingContraint?.constant -= (center.x - lastTranslation.x)
        }
        self.mainView.layer.shadowOpacity = 0.25
        //this allows only swipe-right
        //        isSwipeSuccessful = frame.origin.x > frame.size.width / 2.0  //pan is 1/2 width of the cell
        
        //this allows only swipe-left
        isSwipeSuccessful = frame.origin.x < -frame.size.width / 3.0  //pan is 1/3 width of the cell
        lastTranslation = center
    }
    
    private func moveViewBackIntoPlace(originalFrame: CGRect) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = originalFrame
            self.shadowAnimation.duration = 0.5
            self.mainView.layer.add(self.shadowAnimation, forKey: self.shadowAnimation.keyPath)
            self.mainView.layer.shadowOpacity = 0.0
            self.deleteViewLeadingContraint?.constant = 0
            self.lastTranslation.x = 0
            self.layoutIfNeeded()
        })
    }
    
    private func moveViewBackIntoPlaceSlowly(originalFrame: CGRect) {
        UIView.animate(withDuration: 1.5, animations: {
            self.frame = originalFrame
            self.shadowAnimation.duration = 1.5
            self.mainView.layer.add(self.shadowAnimation, forKey: self.shadowAnimation.keyPath)
            self.mainView.layer.shadowOpacity = 0.0
            self.deleteViewLeadingContraint?.constant = 0
            self.lastTranslation.x = 0
            self.layoutIfNeeded()
        })
    }
    
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
            $0.centerX == contentView.centerXAnchor
            $0.bottom == contentView.bottomAnchor - 10
            $0.width == UIScreen.main.bounds.width * 0.95
        }
        
        self.contentView.addSubview(deleteCellView) {
            deleteViewLeadingContraint = $0.trailing == mainView.trailingAnchor
            $0.centerY == mainView.centerYAnchor
            $0.width == 44
            $0.height == 44
        }
        
        self.contentView.bringSubviewToFront(mainView)
        
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
    
    func setupShadowOnDrag() {
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowRadius = 2
        self.mainView.layer.masksToBounds = false
        self.mainView.layer.shadowOpacity = 0
        self.mainView.shadowPath = UIBezierPath(rect: mainView.bounds).cgPath
        self.mainView.layer.shadowRadius = 4
        self.mainView.layer.shadowOffset = CGSize(width: 0, height:0)
    }
    
    func setup(with model: TableViewCellModel) {
        setupShadowOnDrag()
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
