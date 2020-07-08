//
//  ActionTableViewCell.swift
//  Chats
//
//  Created by user on 07.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let topOffset: CGFloat = 8.0
    static let fontSize: CGFloat = 22.0
    
}

class ActionTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .medium)
        return button
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        selectionStyle = .none
        addSubview(actionButton) {
            $0.top == topAnchor + Constants.topOffset
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.centerY == centerYAnchor
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? ActionTableViewCellModel else { return }
        if let title = model.title {
            actionButton.setTitle(title, for: .normal)
        }
        actionButton.setTitleColor(model.optionType.buttonTextColor, for: .normal)
    }
}
