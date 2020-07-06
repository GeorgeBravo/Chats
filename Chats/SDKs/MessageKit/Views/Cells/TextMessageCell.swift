/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

/// A subclass of `MessageContentCell` used to display text messages.
open class TextMessageCell: MessageContentCell {

    // MARK: - Properties

    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }

    /// The label used to display the message's text.
    open var messageLabel = MessageLabel()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.red
        
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Methods

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.textInsets = attributes.messageLabelInsets
            messageLabel.messageLabelFont = attributes.messageLabelFont
            messageLabel.frame = messageContainerView.bounds
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    open override func setupSubviews() {
        messagesContainerView.addSubview(messageTextView) {
            $0.top == messagesContainerView.topAnchor
            $0.bottom == messagesContainerView.bottomAnchor
            $0.leading == messagesContainerView.leadingAnchor
            $0.trailing == messagesContainerView.trailingAnchor
            $0.width == 200
        }
        
        heightConstraint = messagesContainerView.heightAnchor.constraint(equalTo: messageTextView.heightAnchor)
        heightConstraint?.isActive = true
        super.setupSubviews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        messageBottomLabel.sizeToFit()
        // Get glyph index in textview, make sure there is atleast one character present in message
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        // Get CGRect for last character
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
        
        // Check whether enough space is avaiable to show in last line of message, if not add extra height for timestamp

        if lastLineFragmentRect.maxX > (messageTextView.frame.width - messageBottomLabel.frame.width) {
            // Subtracting 5 to reduce little top spacing for timestamp
            heightConstraint?.constant += messageBottomLabel.frame.height
//            print(messageBottomLabel.frame.midY)
//            print(lastLineFragmentRect.midY)
//            print("rwrw")
            //            messageView.frame.size.height += (rightBottomViewHeight - 5)
        }
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            switch message.kind {
            case .text(let text), .emoji(let text):
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageTextView.text = text
                messageTextView.textColor = textColor
                messageLabel.text = text
                messageLabel.textColor = textColor
                if let font = messageLabel.messageLabelFont {
                    messageLabel.font = font
                    messageTextView.font = font
                }
            case .attributedText(let text):
                messageLabel.attributedText = text
                messageTextView.attributedText = text
            default:
                break
            }
        }
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return messageLabel.handleGesture(touchPoint)
    }

}
