//
//  AddUserTableViewCell.swift
//  Chats
//
//  Created by user on 14.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 20.0
    static let topOffset: CGFloat = 6.0
    static let profileImageHeight: CGFloat = 40.0
    static let separatorHeight: CGFloat = 1.0
    static let bigFontSize: CGFloat = 18.0
}

class AddContactsTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var addContactImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var addContactsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .optionsBlueColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.bigFontSize, style: .regular)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addContactImageView.image = nil
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(addContactImageView) {
            $0.top == topAnchor + Constants.topOffset
            $0.width == Constants.profileImageHeight
            $0.height == Constants.profileImageHeight
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.centerY == centerYAnchor
        }
        
        addSubview(addContactsLabel) {
            $0.trailing == trailingAnchor - Constants.leadingOffset
            $0.centerY == centerYAnchor
            $0.leading == addContactImageView.trailingAnchor + Constants.leadingOffset
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
        guard let model = model as? AddContactsTableViewCellModel else { return }
        var image: UIImage? = nil
        if let imageName = model.imageName { image = UIImage(named: imageName) }
        addContactImageView.image = image
        addContactsLabel.text = model.addContactsText
    }
}


