//
//  PinnedMessageView.swift
//  Chats
//
//  Created by user on 22.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import Photos

class PinnedMessageView: UIView {
    public var onCloseButtonDidTap: (() -> Void)?
    public var onViewDidTap: (() -> Void)?
    
    var editHeightConstraint: NSLayoutConstraint?
    var photoWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.circleCorner = true
        leftVerticalView.circleCorner = true
        cloudMainView.circleCorner = true
    }
    
    // MARK: - Views
    private lazy var cloudMainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorName.paleGray)

        return view
    }()
    
    private lazy var leftVerticalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear//UIColor(named: ColorName.coolGrey)

        return view
    }()
    
    private lazy var containerImageViewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.red

        return imageView
    }()
    
    private lazy var pinnedMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.7, weight: .semibold)
        label.text = "Pinned Message"
        label.textColor = UIColor(named: ColorName.deepSkyBlue)
        label.numberOfLines = 1

        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.3, weight: .regular)
        label.numberOfLines = 1
        label.textColor = UIColor(named: ColorName.deepSkyBlue)

        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blueCloseButton"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)

        return button
    }()
    
    private lazy var borderView = UIView
        .create {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    // MARK: - Public methods
    func setupPinnedMessageView(mockMessage: MockMessage) {
        switch mockMessage.messageKind {
        case let .text(messageText):
            self.bodyLabel.text = messageText
            self.photoWidthConstraint.constant = 0
        case .contact:
            self.bodyLabel.text = "Contact"
            self.photoWidthConstraint.constant = 0
        case .location:
            self.bodyLabel.text = "Geolocation"
            self.photoWidthConstraint.constant = 0
        case let .fileItem(file):
            self.bodyLabel.text = file.fileName
            self.photoWidthConstraint.constant = 0
        case let .asset(mediaItem):
            self.bodyLabel.text = "Photo"
            if let asset = mediaItem.assets?.first {
                let image = getAssetThumbnail(asset: asset)
                self.photoImageView.image = image
            }
            self.photoWidthConstraint.constant = 45
        default:
            self.bodyLabel.text = ""
            self.photoWidthConstraint.constant = 0
            return
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

// MARK: - Setup Views
extension PinnedMessageView {
    private func setupViews() {
        backgroundColor = UIColor(named: ColorName.coolGray235).withAlphaComponent(0.1)
        let viewTapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(viewTapgestureRecognizer)
        
        addSubview(cloudMainView) {
            $0.bottom == bottomAnchor - 3
            $0.leading == leadingAnchor + 10
            $0.trailing == trailingAnchor - 10
            $0.top == topAnchor + 3
        }
        
        cloudMainView.addSubview(borderView) {
            $0.bottom == bottomAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
            $0.height == 0.3
        }
        
        cloudMainView.addSubview(leftVerticalView) {
            $0.leading == leadingAnchor + 15
            $0.centerY == centerYAnchor
            $0.width == 3
            $0.height == 36
        }
        
        cloudMainView.addSubview(containerImageViewView)
        let leadingContainerImageViewView = containerImageViewView.leadingAnchor.constraint(equalTo: leftVerticalView.trailingAnchor, constant: 9)
        let centerYContainerImageViewView = containerImageViewView.topAnchor.constraint(equalTo: leftVerticalView.topAnchor)
        let heightContainerImageViewView = containerImageViewView.bottomAnchor.constraint(equalTo: leftVerticalView.bottomAnchor)
        photoWidthConstraint = containerImageViewView.widthAnchor.constraint(equalToConstant: 45)
        NSLayoutConstraint.activate([leadingContainerImageViewView, centerYContainerImageViewView, heightContainerImageViewView, photoWidthConstraint])
        
        containerImageViewView.addSubview(photoImageView)
        let leadingPhotoImageView = photoImageView.leadingAnchor.constraint(equalTo: containerImageViewView.leadingAnchor)
        let topPhotoImageView = photoImageView.topAnchor.constraint(equalTo: containerImageViewView.topAnchor)
        let bottomPhotoImageView = photoImageView.bottomAnchor.constraint(equalTo: containerImageViewView.bottomAnchor)
        let widthPhotoImageView = photoImageView.widthAnchor.constraint(equalTo: containerImageViewView.widthAnchor, multiplier: 4/5)
        NSLayoutConstraint.activate([leadingPhotoImageView, topPhotoImageView, bottomPhotoImageView, widthPhotoImageView])
        
        
        cloudMainView.addSubview(closeButton) {
            $0.trailing == trailingAnchor - 15
            $0.centerY == centerYAnchor
            $0.size([\.all: 40])
            
        }
        
        cloudMainView.addSubview(pinnedMessageLabel) {
            $0.bottom == leftVerticalView.centerYAnchor
            $0.leading == containerImageViewView.trailingAnchor
        }
        
        cloudMainView.addSubview(bodyLabel) {
            $0.top == leftVerticalView.centerYAnchor
            $0.leading == pinnedMessageLabel.leadingAnchor
            $0.trailing == closeButton.leadingAnchor - 18
        }
    }
}

// MARK: - Actions
extension PinnedMessageView {
    @objc private func closeButtonDidTap() {
        onCloseButtonDidTap?()
    }
    
    @objc private func viewDidTap() {
        onViewDidTap?()
    }
}
