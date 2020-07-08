//
//  ChatSectionHeaderView.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class ChatSectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewSetup {
    
    // MARK: - Variables
    private lazy var titleLabel = UILabel.create {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(named: .optionsBlackColor)
        $0.textAlignment = .center
    }
    
    // MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Views
extension ChatSectionHeaderView {
    private func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(titleLabel) {
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
        }
    }
    
    public func setup(with viewModel: TableViewSectionModel) {
        titleLabel.text = viewModel.title
    }
}
