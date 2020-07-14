//
//  CollocutorNavigationView.swift
//  Chats
//
//  Created by user on 10.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let topButtonSpacing: CGFloat = 4.0
    static let horizontalButtonSpacing: CGFloat = 16.0
    static let horizontalLabelSpacing: CGFloat = 8.0
    static let separatorLineHeight: CGFloat = 0.5
    static let fontSize: CGFloat = 20.0
}

protocol CollocutorNavigationViewDelegate: class {
    func backButtonTapped()
    func editButtonPressed()
}

class CollocutorNavigationView: UIView {
    
    // MARK: - Variables
    weak var delegate: CollocutorNavigationViewDelegate?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "backBarButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalizationKeys.edit.localized(), for: .normal)
        button.setTitleColor(UIColor(named: .blackColor), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .regular)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: ColorName.blackColor)
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.fontSize, style: .bold)
        return label
    }()
    
    private var separatorView = UIView()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Logic
    func setup(with title: String?) {
        tintColor = title == nil ? .clear : UIColor(named: .whiteColor)
        backgroundColor = title == nil ? .clear : UIColor(named: .whiteColor)
        titleLabel.text = title
    }
    
    func setSeparator(visible: Bool) {
        separatorView.isHidden = !visible
    }
    
    func getTitleLabelMaxY() -> CGFloat {
        return titleLabel.frame.midY
    }
}

extension CollocutorNavigationView {
    func setupViews() {
        backgroundColor = .clear
        tintColor = .clear
        
        addSubview(backButton) {
            $0.top == topAnchor + Constants.topButtonSpacing
            $0.centerY == centerYAnchor
            $0.leading == leadingAnchor + Constants.horizontalButtonSpacing
        }
        
        addSubview(editButton) {
            $0.top == topAnchor + Constants.topButtonSpacing
            $0.centerY == centerYAnchor
            $0.trailing == trailingAnchor - Constants.horizontalButtonSpacing
        }
        
        addSubview(titleLabel) {
            $0.centerY == centerYAnchor
            $0.centerX == centerXAnchor
            $0.trailing <= editButton.leadingAnchor - Constants.horizontalLabelSpacing
            $0.leading >= backButton.trailingAnchor + Constants.horizontalLabelSpacing
        }
        
        separatorView.backgroundColor = UIColor(named: .separatorColor)
        separatorView.isHidden = true
        addSubview(separatorView) {
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
            $0.height == Constants.separatorLineHeight
        }
    }
}

// MARK: - Selectors
extension CollocutorNavigationView {
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    @objc func editButtonTapped() {
        delegate?.editButtonPressed()
    }
}
