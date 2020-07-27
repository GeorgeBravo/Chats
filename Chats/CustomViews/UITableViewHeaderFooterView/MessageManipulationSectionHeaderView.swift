//
//  MessageManipulationSectionHeaderView.swift
//  Chats
//
//  Created by user on 21.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let heightValue: CGFloat = 8.0
}

class MessageManipulationSectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewSetup {
    
    // MARK: - UI Variables
    private var coloredSeparatorView: UIView = {
        let view = UIView(frame: .zero)
        view.tintColor = .clear
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Variables
    private lazy var widthConstraint = NSLayoutConstraint(item: coloredSeparatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    
    private lazy var heightConstraint = NSLayoutConstraint(item: coloredSeparatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    
    // MARK: - Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup(with model: TableViewSectionModel) {
        guard let model = model as? MessageManipulationTableViewSectionModel else { return }
        widthConstraint.constant = model.widthConstant
        heightConstraint.constant = model.heightConstant
        var fillColor = UIColor.clear
        if let fillColorName = model.fillColorName {
            fillColor = UIColor(named: fillColorName)
        }
        coloredSeparatorView.backgroundColor = fillColor
        layoutIfNeeded()
    }
    
    // MARK: - UI
    func setupViews() {
        let customBackgroundView = UIView(frame: bounds)
        customBackgroundView.backgroundColor = .clear
        backgroundView = customBackgroundView
        
        addSubview(coloredSeparatorView) {
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
            $0.height == heightAnchor
        }
        addConstraints([widthConstraint, heightConstraint])
    }
    
}


