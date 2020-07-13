
import UIKit

/// A subclass of `MessageCollectionViewCell` used to display the typing indicator.
final class TypingIndicatorCell: UITableViewCell {

    // MARK: - Subviews

    public var insets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)

    public let typingBubble = TypingBubble()

    // MARK: - Initialization


    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupSubviews() {
        addSubview(typingBubble) {
            $0.leading == leadingAnchor + 16
            $0.top == topAnchor + 5
            $0.bottom == bottomAnchor - 5
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if typingBubble.isAnimating {
            typingBubble.stopAnimating()
        }
    }

    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
