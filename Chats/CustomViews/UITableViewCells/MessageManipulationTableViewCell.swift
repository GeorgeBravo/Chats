//
//  MessageManipulationTableViewCell.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let bodyWidth: CGFloat = 240.0
    static let topOffset: CGFloat = 8.0
    static let labelLeadingOffset: CGFloat = 12.0
    static let separatorHeight: CGFloat = 0.5
    static let fontSize: CGFloat = 20.0
    static let cornerRadius: CGFloat = 10.0
    static let imageHorizontalOffset: CGFloat = 4.0
    static let imageHeight: CGFloat = 24.0
}

class MessageManipulationTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variable
    private var model: MessageManipulationTableViewCellModel?
    
    // MARK: - UI Variables
    lazy var alertCellBodyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var manipulationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(named: .optionsBlackColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .medium)
        return label
    }()
    
    private lazy var manipulationIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        setupGestureGecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Logic
    override func prepareForReuse() {
        super.prepareForReuse()
        manipulationIconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alertCellBodyView.roundCorners([.allCorners], radius: 0.0)
        guard let model = model else { return }
        if model.isFirstOption {
            alertCellBodyView.roundCorners([.topLeft, .topRight], radius: Constants.cornerRadius)
        }
        separatorView.isHidden = false
        if model.isLastOption {
            alertCellBodyView.roundCorners([.bottomLeft, .bottomRight], radius: Constants.cornerRadius)
            separatorView.isHidden = true
        }
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(alertCellBodyView) {
            $0.top == topAnchor
            $0.bottom == bottomAnchor
            $0.centerX == centerXAnchor
            $0.width == Constants.bodyWidth
        }
        
        alertCellBodyView.addSubview(manipulationDescriptionLabel) {
            $0.top == alertCellBodyView.topAnchor + Constants.topOffset
            $0.bottom == alertCellBodyView.bottomAnchor - Constants.topOffset
            $0.leading == alertCellBodyView.leadingAnchor + Constants.labelLeadingOffset
        }
        
        alertCellBodyView.addSubview(manipulationIconImageView) {
            $0.height == Constants.imageHeight
            $0.width == Constants.imageHeight
            $0.centerY == alertCellBodyView.centerYAnchor
            $0.trailing == alertCellBodyView.trailingAnchor - Constants.labelLeadingOffset
            $0.leading >= manipulationDescriptionLabel.trailingAnchor + Constants.imageHorizontalOffset
        }

        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.height == Constants.separatorHeight
            $0.leading == alertCellBodyView.leadingAnchor
            $0.trailing == alertCellBodyView.trailingAnchor
        }
    }
    
    private func setupGestureGecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageManipulationTapped))
        alertCellBodyView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setup(with model: TableViewCellModel) {
        guard let model = model as? MessageManipulationTableViewCellModel else { return }
        self.model = model
        manipulationDescriptionLabel.text = model.manipulationType.stringDescription
        manipulationIconImageView.image = model.manipulationType.image
    }
    
    // MARK: - Selector
    @objc func messageManipulationTapped() {
        model?.messageManipulationTapped()
    }
}
