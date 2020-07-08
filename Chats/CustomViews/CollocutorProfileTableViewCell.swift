//
//  CollocutorProfileTableHeaderView.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let profileImageHeight: CGFloat = 140.0
    static let imageTopSpacing: CGFloat = 8.0
    static let separatorHeight: CGFloat = 0.4
}

class CollocutorProfileTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private lazy var collocutorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.profileImageHeight / 2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var collocutorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(named: .blackColor)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: .blackColor)
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
    
}

extension CollocutorProfileTableViewCell {
    private func setupViews() {
        addSubview(collocutorImageView) {
            $0.top == topAnchor + Constants.imageTopSpacing
            $0.centerX == centerXAnchor
            $0.height == Constants.profileImageHeight
            $0.width == Constants.profileImageHeight
        }
        
        addSubview(collocutorNameLabel) {
            $0.top == collocutorImageView.bottomAnchor + Constants.imageTopSpacing
            $0.centerX == centerXAnchor
            $0.bottom == bottomAnchor - Constants.imageTopSpacing
        }
        
        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.height == Constants.separatorHeight
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
        }
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? CollocutorInfoCellModel else { return }
        collocutorImageView.image = model.image
        collocutorNameLabel.text = model.name
        collocutorNameLabel.font = UIFont.systemFont(ofSize: model.fontSize, weight: .heavy)
    }
}
