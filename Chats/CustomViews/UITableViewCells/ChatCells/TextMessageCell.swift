//
//  TextMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let textViewLineSpacing: CGFloat = 3.0
    static let textViewFontSize: CGFloat = 16.0
    static let textFromDateViewSpacing: CGFloat = 12.0
    static let messageTextViewBottomSpacing: CGFloat = 0.0
    static let messageTextViewTrailingSpacing: CGFloat = 5.0
}

final class TextMessageCell: MessageContentCell, TableViewCellSetup {
    
    //MARK: - Variables
    private var messageTextViewBottomConstraint: NSLayoutConstraint?
    private var messageTextViewTrailingConstraint: NSLayoutConstraint?
    private var messageTextViewMaxWidthConstraint: NSLayoutConstraint?
    private var messageTextViewMinWidthConstraint: NSLayoutConstraint?
    
    // MARK: - UI Variables
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        
        return textView
    }()
    
    //MARK: - Inits
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override logic
    public override func prepareForReuse() {
        super.prepareForReuse()
        messageTextViewBottomConstraint?.constant = Constants.messageTextViewBottomSpacing
        messageTextViewTrailingConstraint?.constant = -Constants.messageTextViewTrailingSpacing
        messageTextViewMinWidthConstraint?.constant = UIScreen.main.bounds.width * 0.3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup logic
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewTextMessageCellModel else { return }
        setupTextView(with: model)
    }
    
    private func setupTextView(with model: ChatTableViewTextMessageCellModel) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = Constants.textViewLineSpacing
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            .font: UIFont.helveticaNeueFontOfSize(size: Constants.textViewFontSize, style: .regular),
            .foregroundColor: model.isIncomingMessage ? UIColor.black : UIColor.white
        ]
        
        messageTextView.attributedText = NSAttributedString(string: model.message, attributes: attributes)
        let textLength = model.message.size(withAttributes: attributes).width
        layoutTextViewIfNeeded(with: model, textLength: textLength)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        super.setupSubviews()
        selectionStyle = .none
        
        messageContainerView.addSubview(messageTextView) {
            $0.top == messageContainerView.topAnchor
            $0.leading == messageContainerView.leadingAnchor + Constants.messageTextViewTrailingSpacing
            
            messageTextViewTrailingConstraint = $0.trailing == messageContainerView.trailingAnchor - Constants.messageTextViewTrailingSpacing
            messageTextViewBottomConstraint = $0.bottom == messageContainerView.bottomAnchor + Constants.messageTextViewBottomSpacing
            messageTextViewMaxWidthConstraint = $0.width <= UIScreen.main.bounds.width * 0.6
            messageTextViewMinWidthConstraint = $0.width >= UIScreen.main.bounds.width * 0.3
            
            messageTextViewBottomConstraint?.priority = UILayoutPriority(rawValue: 999)
            messageTextViewMaxWidthConstraint?.priority = UILayoutPriority(rawValue: 900)
        }
    }
    
    func layoutTextViewIfNeeded(with model: ChatTableViewTextMessageCellModel, textLength: CGFloat) {
        let horizontalContainerViewSize = countHorizontalStackViewContainerViewSize(model: model)
        let maxViewWidth = UIScreen.main.bounds.width * 0.6
        messageTextView.frame = CGRect(0.0, 0.0, maxViewWidth, 0.0)
        let textViewSideSpacings: CGFloat = 10 // default TextView textRect insets (5,5)
        let maxTextRectWidth = maxViewWidth - textViewSideSpacings
        let lastLineMaxX = getLastLineMaxX(with: model.message)
        let numberOfLines = (textLength / (maxTextRectWidth)).rounded(.up)
        let horizontalViewSideSpacings = countHorizontalContainerSideSpacings()
        let totalTrailingNeededSpacing = horizontalContainerViewSize.width + horizontalViewSideSpacings
        let totalBottomSpacing = horizontalContainerViewSize.height + Constants.messageTextViewBottomSpacing
        
        if lastLineMaxX < maxViewWidth && numberOfLines == 1 {
            let totalFreeWidth = maxTextRectWidth - totalTrailingNeededSpacing
            
            if lastLineMaxX < totalFreeWidth {
                messageTextViewMinWidthConstraint?.constant = lastLineMaxX
                messageTextViewTrailingConstraint?.constant = -totalTrailingNeededSpacing
            } else {
                messageTextViewBottomConstraint?.constant = -totalBottomSpacing
            }
        } else {
            let messageTextViewSpacingToHorizontalView = maxViewWidth - textViewSideSpacings * numberOfLines - lastLineMaxX - horizontalContainerViewSize.width - horizontalViewSideSpacings - horizontalViewTrailingValue() - Constants.messageTextViewTrailingSpacing
            if messageTextViewSpacingToHorizontalView <= 0 {
                messageTextViewBottomConstraint?.constant = -totalBottomSpacing
            } else {
                messageTextViewMinWidthConstraint?.constant = lastLineMaxX + horizontalContainerViewSize.width + horizontalViewSideSpacings + horizontalViewTrailingValue() + Constants.messageTextViewTrailingSpacing
            }
        }
        messageTextViewBottomConstraint?.isActive = true
        messageTextViewTrailingConstraint?.isActive = true
    }
    
    func getLastLineMaxX(with message: String) -> CGFloat {
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: message.count - 1)
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        return lastLineFragmentRect.maxX
    }
    
}
