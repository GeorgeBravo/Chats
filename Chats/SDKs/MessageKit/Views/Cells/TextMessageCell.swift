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

final class TextMessageCell: MessageContentCell {
    
    //MARK: Lifecycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties

    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.red
        textView.backgroundColor = UIColor.clear
        
        textView.layer.borderColor = UIColor.green.cgColor
        textView.layer.borderWidth = 3
        
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Methods


    public override func prepareForReuse() {
        heightConstraint?.constant = 0
        super.prepareForReuse()
    }

    private func setupViews() {
        messagesContainerView.addSubview(messageTextView) {
            $0.top == messagesContainerView.topAnchor
            $0.bottom == messagesContainerView.bottomAnchor
            $0.leading == messagesContainerView.leadingAnchor
            $0.trailing == messagesContainerView.trailingAnchor
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
        
        heightConstraint = messagesContainerView.heightAnchor.constraint(equalTo: messageTextView.heightAnchor)
        heightConstraint?.isActive = true
    }

    private func layoutTextViewIfNeeded() {
        messageTextView.sizeToFit()
        let lastGlyphIndex = messageTextView.layoutManager.glyphIndexForCharacter(at: messageTextView.text.count - 1)
        // Get CGRect for last character
        let lastLineFragmentRect = messageTextView.layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
    
        if lastLineFragmentRect.maxX > (messageTextView.frame.width - readMessageImageContainerView.frame.width) {
            
            heightConstraint?.constant += 8
//            heightConstraint?.constant += readMessageImageContainerView.frame.height
        }
    }
}
