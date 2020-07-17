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
//            self.layoutTextViewIfNeeded()
//            self.bla = true
        }
    }
    
    //    var bla = false
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        messageTextView.text = ""
//        verticalSpacingConstraint?.constant = 0
//        heightConstraint?.constant = 0
    }
    
    // MARK: - Views
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        
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
        
//        layoutTextViewIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layoutTextViewIfNeeded()
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
            
//            $0.height == 100
        }
        
//        heightConstraint = messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        
//        heightConstraint?.isActive = true
//        messageTextView.translatesAutoresizingMaskIntoConstraints = false
    
//        verticalSpacingConstraint = messageTextView.bottomAnchor.constraint(greaterThanOrEqualTo: horizontalStackView.topAnchor)
        
//        verticalSpacingConstraint?.isActive = true
    }
    
    func layoutTextViewIfNeeded() {
                
        //        layoutSubviews()
        
        
        
        //        messageTextView.layoutManager.ensureLayout(for: messageTextView.textContainer)
        
        
        
        //        guard let pos2 = messageTextView.position(from: messageTextView.endOfDocument, offset: 0), let pos1 = messageTextView.position(from: messageTextView.endOfDocument, offset: -1) ,let range = messageTextView.textRange(from: pos1, to: pos2) else { return }
        //
        //        let lastCharRect = messageTextView.firstRect(for: range)
        //        let freeSpace = messageTextView.frame.size.width - lastCharRect.origin.x - lastCharRect.size.width
        //
        //        if freeSpace < horizontalStackView.frame.width - 10 {
        //            messageTextView.text.append(contentsOf: "\n")
        ////            print("sosi")
        //            return
        //        }
        
//        messageTextView.sizeToFit()
//        messageContainerView.sizeToFit()
//        horizontalStackView.sizeToFit()
        
//        heightConstraint?.constant = messageTextView.intrinsicContentSize.height
        
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
//        if lastLineFragmentRect.maxX >= (horizontalStackView.frame.minX) {
            print("sosi")
//            heightConstraint?.constant = messageTextView.frame.height + 20
            verticalSpacingConstraint?.constant = 10
            print("Height is \(messageTextView.frame.height)")
        } else {
            verticalSpacingConstraint?.constant = -10
        }
    }
}
