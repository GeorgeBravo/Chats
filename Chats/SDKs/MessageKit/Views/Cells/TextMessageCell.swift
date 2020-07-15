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
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
//        heightConstraint?.isActive = false
        messageTextView.text = ""
        super.prepareForReuse()
        messageTextView.text = ""
//        heightConstraint?.isActive = false
//        heightConstraint?.constant = 0
        
    }
    
    // MARK: - Views
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewTextMessageCellModel else { return }
        
//        messageTextView.textColor = model.isIncomingMessage ? UIColor.black : UIColor.white
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            .font: UIFont.helveticaNeueFontOfSize(size: 16, style: .regular),
            .foregroundColor: model.isIncomingMessage ? UIColor.black : UIColor.white
        ]
        messageTextView.attributedText = NSAttributedString(string: model.message, attributes: attributes)
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
//            top.priority = .defaultLow
            let bottom = $0.bottom == messageContainerView.bottomAnchor
//            bottom.priority = .defaultLow
            $0.leading == messageContainerView.leadingAnchor + 5
            $0.trailing == messageContainerView.trailingAnchor
            $0.width >= UIScreen.main.bounds.width * 0.3
            $0.width <= UIScreen.main.bounds.width * 0.6
        }

        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = messageContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        
        heightConstraint?.isActive = true
        
        //        heightConstraint?.priority = .defaultHigh
        
        layoutTextViewIfNeeded()
    }
    
     func layoutTextViewIfNeeded() {
        messageTextView.sizeToFit()
//        layoutSubviews()

        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
//        heightConstraint?.constant = messageTextView.frame.height
        
        print(lastLineFragmentRect.maxX)
        print(horizontalContainerStackView.frame.origin.x)
        if lastLineFragmentRect.maxX > (horizontalContainerStackView.frame.origin.x) {
            messageTextView.text.append(contentsOf: "\n   ")
//            heightConstraint?.constant = horizontalContainerStackView.frame.height + messageTextView.frame.height
//            heightConstraint?.isActive = true
            //            heightConstraint?.constant += readMessageImageContainerView.frame.height
        } else {
//            heightConstraint?.constant = messageTextView.frame.height
        }
        
//        layoutSubviews()
//        setNeedsLayout()
    }
}
