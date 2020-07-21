//
//  GroupProfileTableViewCell.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let topOffset: CGFloat = 16.0
    static let descriptionFontSize: CGFloat = 20.0
    static let profileImageHeight: CGFloat = 68.0
    static let separatorHeight: CGFloat = 0.5
    static let bigFontSize: CGFloat = 20.0
    static let stackViewItemsSpacing: CGFloat = 4.0
    static let smallFontSize: CGFloat = 14.0
}

class GroupProfileTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var groupLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = Constants.profileImageHeight / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .blackColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.bigFontSize, style: .bold)
        return label
    }()
    
    private lazy var membersCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .optionsBlackColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.smallFontSize, style: .regular)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: .coolGrey)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupLogoImageView.image = nil
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(groupLogoImageView) {
            $0.top == topAnchor + Constants.topOffset
            $0.width == Constants.profileImageHeight
            $0.height == Constants.profileImageHeight
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.centerY == centerYAnchor
        }
        
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.stackViewItemsSpacing
        stackView.addArrangedSubview(groupNameLabel)
        stackView.addArrangedSubview(membersCountLabel)
        
        addSubview(stackView) {
            $0.top >= groupLogoImageView.topAnchor
            $0.bottom <= groupLogoImageView.bottomAnchor
            $0.centerY == groupLogoImageView.centerYAnchor
            $0.leading == groupLogoImageView.trailingAnchor + Constants.leadingOffset
            $0.trailing <= trailingAnchor - Constants.leadingOffset
        }
        
        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.height == Constants.separatorHeight
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.trailing == trailingAnchor
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? GroupProfileTableViewCellModel else { return }
        var image: UIImage? = nil
        if let imageName = model.imageName { image = UIImage(named: imageName) }
        groupLogoImageView.image = image
        groupNameLabel.text = model.groupNameText
        membersCountLabel.text = model.membersCountText
    }
}
