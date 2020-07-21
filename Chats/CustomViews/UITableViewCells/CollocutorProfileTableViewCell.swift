//
//  CollocutorProfileTableHeaderView.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let profileImageHeight: CGFloat = 100.0
    static let nameLabelTopSpacing: CGFloat = 8.0
    static let labelTopSpacing: CGFloat = 2.0
    static let separatorHeight: CGFloat = 0.5
    static let lastSeenLabelFontSize: CGFloat = 16.0
    static let buttonStackLeadingOffset: CGFloat = 32.0
    static let buttonStackTopOffset: CGFloat = 24.0
    static let fontSize: CGFloat = 28.0
    static let minFontSize: CGFloat = 20.0
}

class CollocutorProfileTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private var model: CollocutorInfoCellModel?
    
    private lazy var collocutorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.profileImageHeight / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var collocutorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .bold)
        label.textColor = UIColor(named: .blackColor)
        return label
    }()
    
    private lazy var lastSeenLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.lastSeenLabelFontSize, style: .regular)
        label.textColor = UIColor(named: .presenceDescriptionColor)
        return label
    }()
    
    private lazy var buttonsStackView: CollocutorManipulationsButtonsStackView = {
        let stackView = CollocutorManipulationsButtonsStackView()
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: .blackColor)
        view.alpha = 0.1
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
    
    func getCollocutorNameLabelMaxY() -> CGFloat {
        return collocutorNameLabel.frame.midY
    }
    
}

extension CollocutorProfileTableViewCell {
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(collocutorImageView) {
            $0.top == topAnchor
            $0.centerX == centerXAnchor
            $0.height == Constants.profileImageHeight
            $0.width == Constants.profileImageHeight
        }
        
        addSubview(collocutorNameLabel) {
            $0.top == collocutorImageView.bottomAnchor + Constants.nameLabelTopSpacing
            $0.centerX == centerXAnchor
        }
        
        addSubview(lastSeenLabel) {
            $0.top == collocutorNameLabel.bottomAnchor + Constants.labelTopSpacing
            $0.centerX == centerXAnchor
        }
        
        addSubview(buttonsStackView) {
            $0.top == lastSeenLabel.bottomAnchor + Constants.buttonStackTopOffset
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
        _ = update(with: 0.0)
        lastSeenLabel.text = model.lastSeenDescriptionText
        buttonsStackView.delegate = self
    }
    
    func update(with offset: CGFloat) {
        let previousFontSize = collocutorNameLabel.font.pointSize
        let newFontSize = collocutorNameLabelFontSize(with: offset)
        collocutorNameLabel.layer.removeAllAnimations()
        let scale = newFontSize / previousFontSize
        UIView.animate(withDuration: 1.25) { [weak self] in
            self?.collocutorNameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func collocutorNameLabelFontSize(with offset: CGFloat) -> CGFloat {
        var fontSize = Constants.fontSize
        if offset > Constants.profileImageHeight * 0.5 {
            fontSize = fontSize - (offset - Constants.profileImageHeight * 0.5) * 0.23
            if fontSize > Constants.fontSize { fontSize = Constants.fontSize }
            if fontSize < Constants.minFontSize { fontSize = Constants.minFontSize }
        }
        return fontSize
    }
    
}

extension CollocutorProfileTableViewCell: CollocutorManipulationsButtonsStackViewDelegate {
    func buttonPressed(with action: CollocutorOptionType) {
        model?.manipulationCallback?(action)
    }
}
