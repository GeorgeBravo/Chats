//
//  TextMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class TextMessageCell: MessageContentCell, TableViewCellSetup {
    
    //MARK: Lifecycle
    
    var onTextViewDidChange: (() -> Void)?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        heightConstraint?.constant = 0
        messageTextView.text = nil
        super.prepareForReuse()
    }
    
    // MARK: - Views
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.red
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewTextMessageCellModel else { return }
        
        messageTextView.text = "sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi sosi "
        
        //        messageTextView.sizeToFit()
        //
        //        layoutIfNeeded()
        onTextViewDidChange?()
        
        messageTextView.textColor = model.isIncomingMessage ? UIColor.black : UIColor.white
        
        messageContainerView.backgroundColor = model.isIncomingMessage ? UIColor.paleGrey : UIColor.coolGrey
        layoutTextViewIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        layoutTextViewIfNeeded()
    }
}

// MARK: - Setup Views
extension TextMessageCell {
    private func setupViews() {
        super.setupSubviews()
        selectionStyle = .none
        
        messageContainerView.addSubview(messageTextView) {
            let top = $0.top == messageContainerView.topAnchor
            top.priority = .defaultLow
            let bottom = $0.bottom == messageContainerView.bottomAnchor
            bottom.priority = .defaultLow
            $0.leading == messageContainerView.leadingAnchor
            $0.trailing == messageContainerView.trailingAnchor
            //            $0.height >= 100
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        //        heightConstraint =  messageContainerView.heightAnchor.constraint(greaterThanOrEqualTo: messageTextView.heightAnchor, constant: 10)
        
        
        //        heightConstraint = messageContainerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        //        heightConstraint?.constant = 200
        
        //        heightConstraint?.priority = .defaultHigh
    }
    
    private func layoutTextViewIfNeeded() {
        //        messageTextView.sizeToFit()
        let size = messageTextView.intrinsicContentSize
        //        heightConstraint?.constant = size.height
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        // Get CGRect for last character
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        
        if lastLineFragmentRect.maxX > (messageTextView.frame.width - readMessageImageContainerView.frame.width) {
            
            heightConstraint?.constant = messageTextView.frame.height + 8
            //            heightConstraint?.constant += readMessageImageContainerView.frame.height
        } else {
            heightConstraint?.constant = messageTextView.frame.height
        }
    }
}
