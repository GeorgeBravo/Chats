//
//  UserTableViewCell.swift
//  Chats
//
//  Created by user on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let topOffset: CGFloat = 8.0
    static let descriptionFontSize: CGFloat = 20.0
    static let profileImageHeight: CGFloat = 48.0
    static let separatorHeight: CGFloat = 0.5
    static let bigFontSize: CGFloat = 18.0
    static let stackViewItemsSpacing: CGFloat = 0.0
    static let mediumFontSize: CGFloat = 14.0
    static let smallFontSize: CGFloat = 12.0
}

class UserTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = Constants.profileImageHeight / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .optionsBlackColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.bigFontSize, style: .medium)
        return label
    }()
    
    private lazy var lastPrescenceTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.mediumFontSize, style: .regular)
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .coolGreyTwo)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.smallFontSize, style: .regular)
        label.text = LocalizationKeys.author.localized()
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
        userImageView.image = nil
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(userImageView) {
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
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(lastPrescenceTimeLabel)
        
        addSubview(stackView) {
            $0.leading == userImageView.trailingAnchor + Constants.leadingOffset
            $0.top >= userImageView.topAnchor
            $0.bottom <= userImageView.bottomAnchor
            $0.centerY == userImageView.centerYAnchor
        }
        
        addSubview(authorLabel) {
            $0.trailing == trailingAnchor - Constants.leadingOffset
            $0.centerY == centerYAnchor
            $0.leading >= stackView.trailingAnchor - Constants.stackViewItemsSpacing
        }
        
        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.height == Constants.separatorHeight
            let leadingSpacing = Constants.leadingOffset * 2 + Constants.profileImageHeight
            $0.leading == leadingAnchor + leadingSpacing
            $0.trailing == trailingAnchor
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? UserTableViewCellModel else { return }
        var image: UIImage? = nil
        if let imageName = model.imageName { image = UIImage(named: imageName) }
        userImageView.image = image
        userNameLabel.text = model.userNameText
        lastPrescenceTimeLabel.textColor = UIColor(named: model.isOnline ? .optionsBlueColor : .steel)
        lastPrescenceTimeLabel.text = model.lastPresenceText
        authorLabel.isHidden = !model.isAuthor
    }
}
