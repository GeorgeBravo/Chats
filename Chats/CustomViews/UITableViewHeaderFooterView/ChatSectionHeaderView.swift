//
//  ChatSectionHeaderView.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class ChatSectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewSetup {
    
    // MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.cornerRadius = containerView.frame.height / 2
    }
    
    // MARK: - Views
    private lazy var titleLabel = UILabel.create {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(named: .optionsBlackColor)
        $0.textAlignment = .center
    }
    
    private lazy var containerView = UIView
        .create { _ in }
}

//MARK: - Setup Views
extension ChatSectionHeaderView {
    private func setupViews() {
        addSubview(containerView) {
            $0.top == topAnchor + 10
            $0.bottom == bottomAnchor - 10
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
        }
        
        containerView.addSubview(titleLabel) {
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
            $0.top == containerView.topAnchor + 5
            $0.leading == containerView.leadingAnchor + 10
            $0.bottom == containerView.bottomAnchor - 5
            $0.trailing == containerView.trailingAnchor - 10
        }
    }
    
    public func setup(with viewModel: TableViewSectionModel) {
        titleLabel.text = viewModel.title
        
        if let model = viewModel as? ChatTableViewSectionModel {
            switch model.headerStyle {
            case .simple:
                titleLabel.textColor = UIColor(named: .optionsBlackColor)
                containerView.backgroundColor = UIColor.clear
            case .bubble:
                titleLabel.textColor = UIColor.white
                containerView.backgroundColor = UIColor(named: .greyish)
            }
        }
    }
}
