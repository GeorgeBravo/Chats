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
        
        observer = horizontalContainerStackView.layer.observe(\.bounds) { object, _ in
            self.layoutTextViewIfNeeded()
            self.bla = true
        }
    }
    
    
    var bla = false
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
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            .font: UIFont.helveticaNeueFontOfSize(size: 16, style: .regular),
            .foregroundColor: model.isIncomingMessage ? UIColor.black : UIColor.white
        ]
        messageTextView.attributedText = NSAttributedString(string: model.message, attributes: attributes)
        
        if bla {
            layoutTextViewIfNeeded()
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let exclusionPath = UIBezierPath(rect: horizontalContainerStackView.frame)
//        messageTextView.textContainer.exclusionPaths = [exclusionPath]
//        layoutTextViewIfNeeded()
    }

}

// MARK: - Setup Views
extension TextMessageCell {
    private func setupViews() {
        super.setupSubviews()
        
//        let imageView = UIImageView(image: UIImage(named: "bubble_full"))
//        mask = imageView
        
        selectionStyle = .none
        
        messageContainerView.addSubview(messageTextView) {
            $0.top == messageContainerView.topAnchor
            $0.bottom == messageContainerView.bottomAnchor
            $0.leading == messageContainerView.leadingAnchor + 5
            $0.trailing == messageContainerView.trailingAnchor
            
            $0.width >= UIScreen.main.bounds.width * 0.3
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
        
//        heightConstraint = messageContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
//
//        heightConstraint?.isActive = true
        
        //        heightConstraint?.priority = .defaultHigh
        
//        layoutTextViewIfNeeded()
        
    }
    
     func layoutTextViewIfNeeded() {
//        messageTextView.sizeToFit()
//        messageContainerView.sizeToFit()
//        layoutSubviews()

        messageTextView.layoutManager.ensureLayout(for: messageTextView.textContainer)
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
//        heightConstraint?.constant = messageTextView.frame.height
        
//        print(lastLineFragmentRect.maxX)
//        print(horizontalContainerStackView.frame.origin.x)
        
        guard let pos2 = messageTextView.position(from: messageTextView.endOfDocument, offset: 0), let pos1 = messageTextView.position(from: messageTextView.endOfDocument, offset: -1) ,let range = messageTextView.textRange(from: pos1, to: pos2) else { return }
        
        let lastCharRect = messageTextView.firstRect(for: range)
        let freeSpace = messageTextView.frame.size.width - lastCharRect.origin.x - lastCharRect.size.width
        
        if freeSpace < horizontalContainerStackView.frame.width - 10 {
            messageTextView.text.append(contentsOf: "\n")
//            print("sosi")
            return
        }
        
        if lastLineFragmentRect.maxX > (messageTextView.frame.width - horizontalContainerStackView.frame.width - 10) {
//            messageTextView.text.append(contentsOf: "\n")
//            print("sosi")
//            heightConstraint?.constant = horizontalContainerStackView.frame.height + messageTextView.frame.height
//            hxeightConstraint?.isActive = true
            //            heightConstraint?.constant += readMessageImageContainerView.frame.height
        } else {
//            heightConstraint?.constant = messageTextView.frame.height
        }
        
//        layoutSubviews()
//        setNeedsLayout()
    }
}
