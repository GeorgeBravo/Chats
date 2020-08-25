//
//  CloseFriendCollectionViewCell.swift
//  Chats
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let userButtonBottomConstraint: CGFloat = 16.0
}

protocol CloseFriendCollectionViewCellDelegate: class {
    
}

class CloseFriendCollectionViewCell: UICollectionViewCell, CollectionViewCellSetup {
    
    // MARK: - UI Variables
    private var userButtonWidthConstraint = NSLayoutConstraint()
    
    private var userButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override logic
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        userButton.layer.cornerRadius = userButton.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Setup logic
    func setupViews() {
        contentView.addSubview(userButton) {
            $0.bottom == contentView.bottomAnchor - Constants.userButtonBottomConstraint
            userButtonWidthConstraint = $0.width == 0
            $0.height == userButton.widthAnchor
            $0.leading >= contentView.leadingAnchor
            $0.centerX == contentView.centerXAnchor
        }
        userButton.imageView?.contentMode = .scaleAspectFill
        userButton.contentHorizontalAlignment = .fill
        userButton.contentVerticalAlignment = .fill
    }
    
    func setup(with viewModel: CollectionViewCellModel) {
        guard let viewModel = viewModel as? CloseFriendCollectionViewCellModel else { return }
        if viewModel.isPhotoCellModel {
            userButton.setImage(nil, for: .normal)
            userButton.backgroundColor = .white
        } else {
            userButton.setImage(viewModel.userImage, for: .normal)
        }
        userButtonWidthConstraint.constant = viewModel.buttonWidth
    }
}
