//
//  OptionSectionHeaderView.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let topOffset: CGFloat = 4.0
    static let bottomOffset: CGFloat = 2.0
    static let fontSize: CGFloat = 17.0
}

class OptionSectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewSetup {
    
    // MARK: - Variables
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium)
        label.textColor = UIColor(named: .optionsBlackColor)
        label.clipsToBounds = true
        label.numberOfLines = 0
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
            $0.top == topAnchor + Constants.topOffset
            $0.bottom == bottomAnchor - Constants.bottomOffset
            $0.trailing == trailingAnchor - Constants.leadingOffset
        }
    }
    
}


