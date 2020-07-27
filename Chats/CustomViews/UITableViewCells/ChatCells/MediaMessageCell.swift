//
//  MediaMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

final class MediaMessageCell: MessageContentCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var playButtonView: PlayButtonView = {
        let playButtonView = PlayButtonView()
        return playButtonView
    }()
    
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
        guard let model = viewModel as? ChatTableViewAssetCellModel else { return }
        if let assets = model.assets.assets, assets.count > 0 {
            setupWith(assets: model.assets)
            playButtonView.isHidden = true
        }
        if let imageData = model.assets.imageData, let image = UIImage(data: imageData) {
            self.assetImageView.image = image
            playButtonView.isHidden = true
        }
        if let _ = model.assets.videoURL {
            self.assetImageView.backgroundColor = .black
            playButtonView.isHidden = false
        }
    }
    
    func setupWith(assets: MediaItem) {
        guard let asset = assets.assets?.first else { return }
        switch asset.mediaType {
        case .image:
            Assets.resolve(asset: asset, size: [\.width: 240, \.height: 240], completion: { [unowned self] image in
                self.assetImageView.image = image
            })
        case .video:
            print("Video")
        case .audio:
            print("Audio")
        default:
            print("Unknown")
        }
    }
}

// MARK: - Setup Views
extension MediaMessageCell: TableViewCellSetup {
    private func setupViews() {
        
        selectionStyle = .none
        
        messageContainerView.addSubview(assetImageView) {
            $0.size([\.width: 240, \.height: 240])
            $0.top == messageContainerView.topAnchor
            $0.bottom == messageContainerView.bottomAnchor
            $0.leading == messageContainerView.leadingAnchor
            $0.trailing == messageContainerView.trailingAnchor
        }
        
        messageContainerView.addSubview(playButtonView) {
            $0.centerY == messageContainerView.centerYAnchor
            $0.centerX == messageContainerView.centerXAnchor
            $0.size([\.all: 35])
        }
        
        super.setupSubviews()
    }
}
