//
//  ChatListSectionHeaderView.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let verticalOffset: CGFloat = 8.0
    static let fontSize: CGFloat = 17.0
}

class ChatListSectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewSetup {
    
    // MARK: - Variables
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.helveticaNeueFontOfSize(size: 12.7, style: .medium)
        label.textColor = UIColor(named: ColorName.coolGrey)
        return label
    }()
    
    // MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup(with viewModel: TableViewSectionModel) {
        titleLabel.text = viewModel.title
    }
    
    // MARK: - UI
    func setupViews() {
        addSubview(titleLabel) {
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.top == topAnchor + Constants.verticalOffset
            $0.centerY == centerYAnchor
        }
    }
}
