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
}

final class TextMessageCell: MessageContentCell, TableViewCellSetup {
    
    //MARK: - Variables
    private var observer: NSKeyValueObservation?
    private var verticalSpacingConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var messageTextViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI Variables
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
    
    //MARK: - Inits
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        observer = horizontalStackView.layer.observe(\.bounds) { object, _ in
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override logic
    public override func prepareForReuse() {
        super.prepareForReuse()
        messageTextView.text = ""
        messageTextViewBottomConstraint = messageTextView.bottomAnchor.constraint(equalTo: horizontalStackViewContainerView.bottomAnchor, constant: (Constants.textViewFontSize / 2 - 2.0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTextViewIfNeeded()
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
        layoutTextViewIfNeeded()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        super.setupSubviews()
        selectionStyle = .none
        
        messageContainerView.addSubview(messageTextView) {
            $0.top == messageContainerView.topAnchor
            $0.leading == messageContainerView.leadingAnchor + 5
            messageTextViewBottomConstraint = $0.bottom == horizontalStackViewContainerView.bottomAnchor + (Constants.textViewFontSize / 2 - 2.0) // Rework for stack height
            $0.trailing == horizontalStackViewContainerView.trailingAnchor + 5
            
            $0.width >= UIScreen.main.bounds.width * 0.3
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
    }
    
    func layoutTextViewIfNeeded() {
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        let lastLineMaxX = lastLineFragmentRect.maxX
        
        print("\n")
        print("text: \(messageTextView.text)")
        print("lastLineMaxX = \(lastLineMaxX)")
        print("messageTextView.frame = \(messageTextView.frame)")
        print("horizontalStackViewContainerView.frame = \(horizontalStackViewContainerView.frame)")
        
        guard messageTextView.frame.width > 0 else { return }
        if horizontalStackViewContainerView.frame.minX < lastLineMaxX {
            messageTextViewBottomConstraint?.constant = -20
            print("messageTextViewBottomConstraint?.constant = -20")
        } else {
            messageTextViewBottomConstraint = messageTextView.bottomAnchor.constraint(equalTo: horizontalStackViewContainerView.bottomAnchor, constant: (Constants.textViewFontSize / 2 - 2.0))
        }
    }
    
}
