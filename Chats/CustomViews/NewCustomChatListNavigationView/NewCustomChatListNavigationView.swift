//
//  NewCustomChatListNavigationView.swift
//  Chats
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let cameraButtonHeightWidth: CGFloat = 44.0
    static let pencilButtonHeightWidth: CGFloat = 44.0
    static let avatarButtonHeightWidth: CGFloat = 44.0
    static let cameraTrailingSpacing: CGFloat = 19.0
    static let pencilLeadingSpacing: CGFloat = 23.0
}

protocol NewCustomChatListNavigationViewDelegate: class {
    func pencilButtonTapped()
    func avatarButtonTapped()
    func cameraButtonTapped()
}

class NewCustomChatListNavigationView: UIView {
    // MARK: - Variables
    weak var delegate: NewCustomChatListNavigationViewDelegate?
    
    private lazy var pencilButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(named: ColorName.coolGray235)
        button.setImage(UIImage(named: "pencilButton"), for: .normal)
        button.addTarget(self, action: #selector(pencilButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "roflan"), for: .normal)
        button.addTarget(self, action: #selector(avatarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cameraButton: CircleProgressButton = {
        let settings = CircleProgressButtonSettings(borderWidth: 2.0, backGroundColor: UIColor(named: ColorName.coolGray235), progressColor: .black, baseImageName: "blackCameraButton", fullProgressImageName: "img2")
        let button = CircleProgressButton(settings: settings)
        button.actionButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraButton.circleCorner = true
        pencilButton.circleCorner = true
    }
}

extension NewCustomChatListNavigationView {
    func setupViews() {
        backgroundColor = .clear
        tintColor = .clear
        
        addSubview(pencilButton) {
            $0.height == Constants.pencilButtonHeightWidth
            $0.centerY == centerYAnchor
            $0.width == Constants.pencilButtonHeightWidth
            $0.leading == leadingAnchor + Constants.pencilLeadingSpacing
        }
        
        addSubview(avatarButton) {
            $0.height == Constants.avatarButtonHeightWidth
            $0.centerY == centerYAnchor
            $0.width == Constants.avatarButtonHeightWidth
            $0.centerX == centerXAnchor
        }
        
        addSubview(cameraButton) {
            $0.height == Constants.cameraButtonHeightWidth
            $0.centerY == centerYAnchor
            $0.width == Constants.cameraButtonHeightWidth
            $0.trailing == trailingAnchor - Constants.cameraTrailingSpacing
        }
    }
}

// MARK: - Selectors
extension NewCustomChatListNavigationView {
    @objc func pencilButtonTapped() {
        delegate?.pencilButtonTapped()
    }
    
    @objc func avatarButtonTapped() {
        delegate?.avatarButtonTapped()
    }
    
    @objc func cameraButtonTapped() {
        delegate?.cameraButtonTapped()
    }
}
