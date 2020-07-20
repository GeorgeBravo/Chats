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
    static let bottomOffset: CGFloat = 12.0
    static let fontSize: CGFloat = 18.0
    static let descriptionFontSize: CGFloat = 17.0
    static let spacingOffset: CGFloat = 12.0
    static let separatorHeight: CGFloat = 0.5
}

class ActionTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .regular)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "backxxlCopy")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionFontSize, style: .regular)
        label.textColor = UIColor(named: .descriptionGrayColor)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: .separatorColor)
        return view
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
        
        addSubview(actionLabel) {
            $0.top == topAnchor + Constants.topOffset
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.bottom == bottomAnchor - Constants.bottomOffset
        }
        
        addSubview(arrowImageView) {
            $0.centerY == actionLabel.centerYAnchor
            $0.trailing == trailingAnchor - Constants.leadingOffset
        }
        
        addSubview(infoLabel) {
            $0.centerY == actionLabel.centerYAnchor
            $0.trailing == arrowImageView.leadingAnchor - Constants.spacingOffset
            $0.leading >= actionLabel.trailingAnchor + Constants.spacingOffset
        }
        
        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.height == Constants.separatorHeight
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.trailing == trailingAnchor
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? ActionTableViewCellModel else { return }
        if let title = model.title {
            actionLabel.text = title
        }
        actionLabel.textColor = UIColor(named: model.optionType.buttonTextColorName)
        infoLabel.text = model.descriptionText
        arrowImageView.isHidden = String.isEmpty(model.descriptionText)
    }
}
