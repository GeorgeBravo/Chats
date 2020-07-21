//
//  DescriptionTableViewCell.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//
import UIKit

private struct Constants {
    static let leadingOffset: CGFloat = 16.0
    static let topOffset: CGFloat = 8.0
    static let descriptionFontSize: CGFloat = 16.0
    static let separatorHeight: CGFloat = 0.5
}

class DescriptionTableViewCell: UITableViewCell, TableViewCellSetup {
    
    // MARK: - Variables
    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionFontSize, style: .regular)
        textView.textColor = UIColor(named: .optionsBlackColor)
        textView.dataDetectorTypes = .all
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        return textView
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
        descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingOffset).isActive = true
        descriptionTextView.layoutIfNeeded()
    }
    
    // MARK: - UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        addSubview(descriptionTextView) {
            $0.top == topAnchor + Constants.topOffset
            $0.leading == leadingAnchor + Constants.leadingOffset
            $0.centerY == centerYAnchor
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
        guard let model = model as? DescriptionTableViewCellModel else { return }
        descriptionTextView.text = model.description
        let constant = model.isShortcut ? 0.0 : Constants.leadingOffset
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: constant, bottom: 0.0, right: 0.0)
    }
}
