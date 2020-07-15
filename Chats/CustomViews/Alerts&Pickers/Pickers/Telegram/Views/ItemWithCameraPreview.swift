//
//  ItemWithCameraPreview.swift
//  Chats
//
//  Created by user on 15.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import AVFoundation
import UIKit

protocol ItemWithCameraPreviewDelegate: class {
    func startCamera()
    func stopCamera()
}

class ItemWithCameraPreview: UICollectionViewCell {
    
    // MARK: - Variables
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: ItemWithCameraPreviewDelegate?
    private var imageLayer = CALayer()
    
    // MARK: - Inits
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
        
        imageLayer = CALayer()
        let cameraImage = #imageLiteral(resourceName: "camera").cgImage
        imageLayer.contents = cameraImage
        layer.addSublayer(imageLayer)
    }
    
    public func setup(with previewLayer: AVCaptureVideoPreviewLayer) {
        backgroundColor = .clear
        cameraPreviewLayer = previewLayer
        if layer.sublayers?.contains(imageLayer) ?? false {
            layer.insertSublayer(cameraPreviewLayer, below: imageLayer)
        } else {
            layer.addSublayer(cameraPreviewLayer)
        }
        delegate?.startCamera()
    }
    
    // MARK: - Logic
    override func prepareForReuse() {
        cameraPreviewLayer.removeFromSuperlayer()
        delegate?.stopCamera()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let cameraPreviewLayer = cameraPreviewLayer else { return }
        cameraPreviewLayer.frame = bounds
        cameraPreviewLayer.contentsRect = bounds
        cameraPreviewLayer.cornerRadius = 12.0
        cameraPreviewLayer.masksToBounds = true
        imageLayer.frame = CGRect(bounds.width * 0.25, bounds.height * 0.25, bounds.width * 0.5, bounds.height * 0.5)
        
    }
    
}
