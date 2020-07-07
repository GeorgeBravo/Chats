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

/// A subclass of `MessageCollectionViewCell` used to display text, media, and location messages.
open class MessageContentCell: MessageCollectionViewCell {

    //MARK: - Views
    
    /// The image view displaying the avatar.
    open var avatarView = AvatarView()

    /// The container used for styling and holding the message's content view.
    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
//        containerView.clipsToBounds = true
//        containerView.layer.masksToBounds = true
//        containerView.backgroundColor = UIColor.yellow
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 1
        return containerView
    }()
    
    public lazy var messagesContainerView: UIView = {
        let containerView = UIView()
        //        containerView.clipsToBounds = true
        //        containerView.layer.masksToBounds = true
//        containerView.backgroundColor = UIColor.yellow
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 1
        return containerView
    }()

    /// The top label of the cell.
    open var cellTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// The bottom label of the cell.
    open var cellBottomLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// The top label of the messageBubble.
    open var messageTopLabel: InsetLabel = {
        let label = InsetLabel()
        label.numberOfLines = 0
        return label
    }()

    /// The bottom label of the messageBubble.
    open var messageBottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var readMessageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doubleCheck")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    public lazy var readMessageImageContainerView: UIView = UIView()
    
    private lazy var smileyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "smiley")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageBottomLabel, readMessageImageContainerView])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        
        return stackView
    }()

    // Should only add customized subviews - don't change accessoryView itself.
    open var accessoryView: UIView = UIView()

    /// The `MessageCellDelegate` for the cell.
    open weak var delegate: MessageCellDelegate?
    
    private var isFromCurrentSender = false
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    open func setupSubviews() {
        readMessageImageContainerView.addSubview(readMessageImageView) {
            $0.centerX == readMessageImageContainerView.centerXAnchor
            $0.centerY == readMessageImageContainerView.centerYAnchor
            $0.leading <= readMessageImageContainerView.leadingAnchor
            $0.trailing <= readMessageImageContainerView.trailingAnchor
            $0.top <= readMessageImageContainerView.topAnchor
            $0.bottom <= readMessageImageContainerView.bottomAnchor
            $0.size([\.width: 15])
        }
        
        contentView.addSubview(messagesContainerView) {
            $0.top == contentView.topAnchor + 2
            $0.bottom == contentView.bottomAnchor - 2
        }
        
        messagesContainerView.addSubview(horizontalStackView) {
            $0.bottom == messagesContainerView.bottomAnchor - 5
            $0.trailing == messagesContainerView.trailingAnchor - 10
        }
        
        horizontalStackView.layout {
            $0.height == 8
        }
    }

    open override func prepareForReuse() {
        accessoryView.removeFromSuperview()
        super.prepareForReuse()
        
        cellTopLabel.text = nil
        cellBottomLabel.text = nil
        messageTopLabel.text = nil
        messageBottomLabel.text = nil
        
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = false
    }

    // MARK: - Configuration

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        // Call this before other laying out other subviews
//        layoutMessageContainerView(with: attributes)
//        layoutMessageBottomLabel(with: attributes)
//        layoutCellBottomLabel(with: attributes)
//        layoutCellTopLabel(with: attributes)
//        layoutMessageTopLabel(with: attributes)
//        layoutAvatarView(with: attributes)
//        layoutAccessoryView(with: attributes)
    }

    /// Used to configure the cell.
    ///
    /// - Parameters:
    ///   - message: The `MessageType` this cell displays.
    ///   - indexPath: The `IndexPath` for this cell.
    ///   - messagesCollectionView: The `MessagesCollectionView` in which this cell is contained.
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        
        self.isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        
        if isFromCurrentSender {
            
            trailingConstraint = messagesContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            trailingConstraint?.isActive = true
        } else {
            leadingConstraint = messagesContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
            leadingConstraint?.isActive = true
            
            messagesContainerView.addSubview(smileyImageView) {
                $0.size([\.all: 20])
                $0.leading == messagesContainerView.trailingAnchor + 10
                $0.top == messagesContainerView.topAnchor + 5
            }
        }
        
        readMessageImageContainerView.isHidden = !isFromCurrentSender
        messageBottomLabel.textColor = isFromCurrentSender ? UIColor.white : UIColor.black.withAlphaComponent(0.5)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        delegate = messagesCollectionView.messageCellDelegate

        let messageColor = displayDelegate.backgroundColor(for: message, at: indexPath, in: messagesCollectionView)
        let messageStyle = displayDelegate.messageStyle(for: message, at: indexPath, in: messagesCollectionView)

        displayDelegate.configureAvatarView(avatarView, for: message, at: indexPath, in: messagesCollectionView)

        displayDelegate.configureAccessoryView(accessoryView, for: message, at: indexPath, in: messagesCollectionView)

        messagesContainerView.backgroundColor = messageColor
        messageContainerView.backgroundColor = messageColor
        messageContainerView.style = messageStyle

        let topCellLabelText = dataSource.cellTopLabelAttributedText(for: message, at: indexPath)
        let bottomCellLabelText = dataSource.cellBottomLabelAttributedText(for: message, at: indexPath)
        let topMessageLabelText = dataSource.messageTopLabelAttributedText(for: message, at: indexPath)
        let bottomMessageLabelText = dataSource.messageBottomLabelAttributedText(for: message, at: indexPath)

        cellTopLabel.attributedText = topCellLabelText
        cellBottomLabel.attributedText = bottomCellLabelText
        messageTopLabel.attributedText = topMessageLabelText
        messageBottomLabel.attributedText = bottomCellLabelText
    }

    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)

        switch true {
        case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            delegate?.didTapMessage(in: self)
        case avatarView.frame.contains(touchLocation):
            delegate?.didTapAvatar(in: self)
        case cellTopLabel.frame.contains(touchLocation):
            delegate?.didTapCellTopLabel(in: self)
        case cellBottomLabel.frame.contains(touchLocation):
            delegate?.didTapCellBottomLabel(in: self)
        case messageTopLabel.frame.contains(touchLocation):
            delegate?.didTapMessageTopLabel(in: self)
        case messageBottomLabel.frame.contains(touchLocation):
            delegate?.didTapMessageBottomLabel(in: self)
        case accessoryView.frame.contains(touchLocation):
            delegate?.didTapAccessoryView(in: self)
        default:
            delegate?.didTapBackground(in: self)
        }
    }

    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return messageContainerView.frame.contains(touchPoint)
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }
}
