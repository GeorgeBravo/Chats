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
}

final class TextMessageCell: MessageContentCell, TableViewCellSetup {
    
    //MARK: - Variables
    private var messageTextViewBottomConstraint: NSLayoutConstraint?
    private var messageTextViewTrailingConstraint: NSLayoutConstraint?
    private var messageTextViewWidthConstraint: NSLayoutConstraint?
    
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
        messageTextViewBottomConstraint?.constant = -7
        messageTextViewTrailingConstraint?.constant = -5
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
            $0.leading == messageContainerView.leadingAnchor + 5
            
            messageTextViewTrailingConstraint = $0.trailing == messageContainerView.trailingAnchor - 5
            messageTextViewBottomConstraint = $0.bottom == messageContainerView.bottomAnchor - 3    //as horizontalStack
            messageTextViewWidthConstraint = $0.width <= UIScreen.main.bounds.width * 0.6
            
            messageTextViewBottomConstraint?.priority = UILayoutPriority(rawValue: 999)
            messageTextViewWidthConstraint?.priority = UILayoutPriority(rawValue: 900)
        }
    }
    
    func layoutTextViewIfNeeded(with model: ChatTableViewTextMessageCellModel, textLength: CGFloat) {
        let horizontalContainerViewSize = countHorizontalStackViewContainerViewSize(model: model)
        let maxViewWidth = UIScreen.main.bounds.width * 0.6
        messageTextView.frame = CGRect(0.0, 0.0, maxViewWidth, 0.0)
        
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: model.message.count - 1)
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        let lastLineMaxX = lastLineFragmentRect.maxX
        let numberOfLines = (textLength / (maxViewWidth - 10)).rounded(.up)
        
        if lastLineMaxX < maxViewWidth && numberOfLines == 1 {
            if lastLineMaxX < maxViewWidth - 10 - horizontalContainerViewSize.width - 5 - 5 {
                messageTextViewTrailingConstraint?.constant = -horizontalContainerViewSize.width - 5 - 5
            } else {
                messageTextViewBottomConstraint?.constant = -horizontalContainerViewSize.height - 3
            }
        } else {
            if maxViewWidth - 10 * numberOfLines - lastLineMaxX - horizontalContainerViewSize.width - 5 - 5 - 10 - 5 <= 0 {
                messageTextViewBottomConstraint?.constant = -horizontalContainerViewSize.height - 3
            }
        }
        messageTextViewBottomConstraint?.isActive = true
        messageTextViewTrailingConstraint?.isActive = true
    }
    
}

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
