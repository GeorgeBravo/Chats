//
//  UnreadMessagesCell.swift
//  Chats
//
//  Created by user on 30.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let fontSize: CGFloat = 18.0
    static let topLabelOffset: CGFloat = 4.0
}

final class UnreadMessagesTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override logic
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup
    func setup(with viewModel: TableViewCellModel) {
        guard let viewModel = viewModel as? UnreadMessagesCellModel else { return }
        titleLabel.text = viewModel.title
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: .paleGray)
        addSubview(titleLabel) {
            $0.top == topAnchor + Constants.topLabelOffset
            $0.bottom == bottomAnchor - Constants.topLabelOffset
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
    }
    
}
