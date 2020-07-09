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
        
        messagesContainerView.backgroundColor = model.isIncomingMessage ? UIColor.paleGrey : UIColor.coolGrey
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
        
        messagesContainerView.addSubview(messageTextView) {
            let top = $0.top == messagesContainerView.topAnchor
            top.priority = .defaultLow
            let bottom = $0.bottom == messagesContainerView.bottomAnchor
            bottom.priority = .defaultLow
            $0.leading == messagesContainerView.leadingAnchor
            $0.trailing == messagesContainerView.trailingAnchor
//            $0.height >= 100
            $0.width <= UIScreen.main.bounds.width * 0.6
        }
        messagesContainerView.translatesAutoresizingMaskIntoConstraints = false
        
//        heightConstraint =  messagesContainerView.heightAnchor.constraint(greaterThanOrEqualTo: messageTextView.heightAnchor, constant: 10)
       
        
//        heightConstraint = messagesContainerView.heightAnchor.constraint(equalToConstant: 0)
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
