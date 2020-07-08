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
    static let labelTopSpacing: CGFloat = 4.0
    static let separatorHeight: CGFloat = 0.4
    static let lastSeenLabelFontSize: CGFloat = 16.0
    static let buttonStackLeadingOffset: CGFloat = 32.0
}

class CollocutorProfileTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private var model: CollocutorInfoCellModel?
    
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
    
    private lazy var lastSeenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Constants.lastSeenLabelFontSize, weight: .regular)
        label.textColor = UIColor(named: .blackColor)
        return label
    }()
    
    private lazy var buttonsStackView: CollocutorManipulationsButtonsStackView = {
        let stackView = CollocutorManipulationsButtonsStackView()
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: .blackColor)
        view.alpha = 0.5
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
        selectionStyle = .none
        
        addSubview(collocutorImageView) {
            $0.top == topAnchor + Constants.imageTopSpacing
            $0.centerX == centerXAnchor
            $0.height == Constants.profileImageHeight
            $0.width == Constants.profileImageHeight
        }
        
        addSubview(collocutorNameLabel) {
            $0.top == collocutorImageView.bottomAnchor + Constants.imageTopSpacing
            $0.centerX == centerXAnchor
        }
        
        addSubview(lastSeenLabel) {
            $0.top == collocutorNameLabel.bottomAnchor + Constants.labelTopSpacing
            $0.centerX == centerXAnchor
        }
        
        addSubview(buttonsStackView) {
            $0.top == lastSeenLabel.bottomAnchor + Constants.buttonStackLeadingOffset
            $0.bottom == bottomAnchor - Constants.buttonStackLeadingOffset
            $0.leading == leadingAnchor + Constants.buttonStackLeadingOffset
            $0.trailing == trailingAnchor - Constants.buttonStackLeadingOffset
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
        self.model = model
        collocutorImageView.image = model.image
        collocutorNameLabel.text = model.name
        collocutorNameLabel.font = UIFont.systemFont(ofSize: model.fontSize, weight: .heavy)
        lastSeenLabel.text = model.lastSeenDescriptionText
        buttonsStackView.delegate = self
    }
}

extension CollocutorProfileTableViewCell: CollocutorManipulationsButtonsStackViewDelegate {
    func buttonPressed(with action: CollocutorManipulations) {
        model?.manipulationCallback?(action)
    }
}
