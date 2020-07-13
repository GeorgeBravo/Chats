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

/// A subclass of `MessageContentCell` used to display video and audio messages.
final class MediaMessageCell: MessageContentCell {

    /// The play button view to display on video messages.
    private lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()

    /// The image view display the media content.
    private lazy var assetImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFill
        }

    // MARK: - Methods

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.assetImageView.image = nil
    }
    
    override func setup(with viewModel: TableViewCellModel) {
    super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewLocationCellModel else { return }
        
//        switch message.kind {
//        case .photo(let mediaItem):
//            assetImageView.image = mediaItem.image ?? mediaItem.placeholderImage
//            playButtonView.isHidden = true
//        case .video(let mediaItem):
//            assetImageView.image = mediaItem.image ?? mediaItem.placeholderImage
//            playButtonView.isHidden = false
//        default:
//            break
//        }

    }
}

// MARK: - Setup Views
extension MediaMessageCell: TableViewCellSetup {
    /// Responsible for setting up the constraints of the cell's subviews.
    private func setupConstraints() {
        assetImageView.fillSuperview()
        playButtonView.centerInSuperview()
        playButtonView.constraint(equalTo: CGSize(width: 35, height: 35))
    }

    private func setupViews() {
        super.setupSubviews()
        messageContainerView.addSubview(assetImageView)
        messageContainerView.addSubview(playButtonView)
        setupConstraints()
    }
}
