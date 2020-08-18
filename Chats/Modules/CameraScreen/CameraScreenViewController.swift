// 
//  CameraScreenViewController.swift
//  Chats
//
//  Created by user on 18.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import AVFoundation
import BRIck

private struct Constants {
    static let descriptionLabelFontSize: CGFloat = 16.0
    static let cameraLayerCornerRadius: CGFloat = 16.0
}

protocol CameraScreenPresentableListener: class {

    func checkAndStartCameraSession()
    func stopCameraSession()
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class CameraScreenViewController: UIViewController {

    //MARK: - Variables
    weak var listener: CameraScreenPresentableListener?
    
    // MARK: - UI Variables
    private var cameraPreviewView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private var touchSignImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "roflan")
        return imageView
    }()
    
    private var newDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionLabelFontSize, style: .medium)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionLabelFontSize, style: .regular)
        return label
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        listener?.checkAndStartCameraSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.stopCameraSession()
    }
}

// MARK: - Setup Views
extension CameraScreenViewController {
    
    private func setupViews() {
        view.backgroundColor = .green
    }
    
}

// MARK: - CameraScreenPresentable
extension CameraScreenViewController: CameraScreenPresentable {
    
    func showNoCameraLabel() {
        print("showNoCameraLabel")
    }
    
    func setup(with previewLayer: AVCaptureVideoPreviewLayer) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = .clear
            self.cameraPreviewLayer = previewLayer
            self.cameraPreviewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.cameraPreviewLayer)
        }
        
    }
}

// MARK: - CameraScreenViewControllable
extension CameraScreenViewController: CameraScreenViewControllable {}
