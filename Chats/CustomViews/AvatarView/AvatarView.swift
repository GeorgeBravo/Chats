//
//  AvatarView.swift
//  Chats
//
//  Created by Eugene Zatserklyaniy on 27.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit


class AvatarView: UIView {
    
    //MARK: - Views
    private lazy var userAvatar = UIImageView.create {
        $0.contentMode = .scaleToFill
        $0.cornerRadius = 33
        $0.clipsToBounds = true
    }
    
    private lazy var onlineView = UIView.create {
        $0.layer.cornerRadius = 15.35
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    private lazy var greenIndicator = UIView.create {
        $0.layer.cornerRadius = 9.65
        $0.clipsToBounds = true
        $0.backgroundColor = .green
    }
    
    private lazy var groupChatTopImageView = UIImageView.create {
        $0.clipsToBounds = true
        $0.cornerRadius = 22.35
    }
    
    private lazy var groupChatBottomImageView = UIImageView.create {
        $0.clipsToBounds = true
        $0.cornerRadius = 22.35
    }
    
    //MARK: - Setup
    func setupView(model: AvatarModel) {
        addSubview(userAvatar) {
            $0.centerY == centerYAnchor
            $0.centerX == centerXAnchor
            $0.width == 66
            $0.height == 66
        }
        
        if let model = model as? UserAvatarModel {
            setupUserAvatar(model: model)
        } else if let model = model as? GroupAvatarModel {
            setupGroupAvatar(model: model)
        }
    }
    
    private func setupUserAvatar(model: UserAvatarModel) {
        userAvatar.cornerRadius = 33
        userAvatar.image = UIImage(named: model.image)
        addOnlineView(isOnline: model.isOnline)
        
        addStoryLayer(hasStory: model.hasStory)
        
        groupChatTopImageView.removeFromSuperview()
        groupChatBottomImageView.removeFromSuperview()
    }
    
    private func setupGroupAvatar(model: GroupAvatarModel) {
        userAvatar.image = nil
        userAvatar.cornerRadius = 0
        userAvatar.addSubview(groupChatTopImageView) {
            $0.top == userAvatar.topAnchor
            $0.trailing == userAvatar.trailingAnchor
            $0.width == 44.7
            $0.height == 44.7
        }
        
        groupChatTopImageView.image = UIImage(named: model.topImage)
        
        userAvatar.addSubview(groupChatBottomImageView) {
            $0.bottom == userAvatar.bottomAnchor
            $0.leading == userAvatar.leadingAnchor
            $0.width == 44.7
            $0.height == 44.7
        }
        groupChatBottomImageView.image = UIImage(named: model.bottomImage)
        
        addOnlineView(isOnline: model.isOnline)
        addStoryLayer(hasStory: false)
        
    }
    
    private func addStoryLayer(hasStory: Bool) {
        if hasStory {
            let radial = GradientView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            radial.backgroundColor = UIColor.clear
            userAvatar.layer.borderColor = UIColor.white.cgColor
            userAvatar.layer.borderWidth = 4
            addSubview(radial) {
                $0.top == userAvatar.topAnchor - 2
                $0.leading == userAvatar.leadingAnchor - 2
                $0.width == 70
                $0.height == 70
            }
            radial.addCircleGradiendBorder(5)
        } else {
            userAvatar.layer.borderWidth = 0
            userAvatar.layer.borderColor = UIColor.clear.cgColor
            for subview in subviews {
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
        addSubview(onlineView) {
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
}
