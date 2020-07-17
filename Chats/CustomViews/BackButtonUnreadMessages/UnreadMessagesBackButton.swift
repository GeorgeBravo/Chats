//
//  UnreadMessagesBackButton.swift
//  Chats
//
//  Created by Касилов Георгий on 30.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class UnreadMessagesBackButton: UIView {
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var unreadMessages: Int? {
        didSet {
            unreadMessagesLabel.text = String(unreadMessages!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = 10
    }
    
    //MARK: - Views
    
    private var unreadMessagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = UIColor.white
        
        return label
    }()

}

//MARK: - Setup Views

extension UnreadMessagesBackButton {
    private func setupViews() {
        self.backgroundColor = UIColor(named: .pinkishRedTwo)
        
        addSubview(unreadMessagesLabel) {
            $0.centerY == centerYAnchor
            $0.leading == leadingAnchor + 5
            $0.trailing == trailingAnchor - 5
        }
    }
}
