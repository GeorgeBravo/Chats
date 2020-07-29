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
    private var observer: NSKeyValueObservation?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        observer = horizontalStackView.layer.observe(\.bounds) { object, _ in
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        messageTextView.text = ""
    }
    
    // MARK: - Views
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator =  false
        textView.showsHorizontalScrollIndicator = false
        
        return textView
    }()
    
    private var verticalSpacingConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Setup
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewTextMessageCellModel else { return }
        setupTextView(with: model)
    }
}

// MARK: - Setup Views
extension TextMessageCell {
    
    private func setupTextView(with model: ChatTableViewTextMessageCellModel) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            .font: UIFont.helveticaNeueFontOfSize(size: 16, style: .regular),
            .foregroundColor: model.isIncomingMessage ? UIColor.black : UIColor.white
        ]
        
        messageTextView.attributedText = NSAttributedString(string: model.message, attributes: attributes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupViews() {
        super.setupSubviews()
        
        selectionStyle = .none
        
        messageContainerView.addSubview(messageTextView) {
            $0.top == messageContainerView.topAnchor
            $0.bottom == horizontalStackView.topAnchor
            $0.leading == messageContainerView.leadingAnchor + 5
            $0.trailing == messageContainerView.trailingAnchor
            
            $0.width >= UIScreen.main.bounds.width * 0.3
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
    }
    
    func layoutTextViewIfNeeded() {
        heightConstraint?.constant = 100
        
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        
        print("\n")
        print(messageTextView.frame)
        print(horizontalStackView.frame)

        print(lastLineFragmentRect.maxX)
        print(horizontalStackView.frame.width)
        print(messageTextView.frame.width - horizontalStackView.frame.width)
        
        if lastLineFragmentRect.maxX > messageTextView.frame.width - horizontalStackView.frame.width {

            verticalSpacingConstraint?.constant = 10
        } else {
            verticalSpacingConstraint?.constant = -10
        }
    }
}
