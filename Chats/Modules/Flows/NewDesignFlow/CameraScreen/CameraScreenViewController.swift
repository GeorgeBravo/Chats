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
    static let descriptionLabelFontSize: CGFloat = 18.0
    static let cameraLayerCornerRadius: CGFloat = 16.0
    static let newDescriptionLabelYCenterSpacing: CGFloat = 8.0
    static let newDescriptionLabelTopSpacing: CGFloat = 36.0
    static let descriptionLabelTopSpacing: CGFloat = 4.0
    static let labelSideSpacing: CGFloat = 16.0
    static let cameraManipulationsStackViewSpacing: CGFloat = 24.0
    static let cameraManipulationsStackViewWidth: CGFloat = 40
}

protocol CameraScreenPresentableListener: class {

    func checkAndStartCameraSession()
    func stopCameraSession()
    func hideCameraScreen()
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class CameraScreenViewController: UIViewController {

    //MARK: - Variables
    weak var listener: CameraScreenPresentableListener?
    
    // MARK: - UI Variables
    private var cameraPreviewView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.maskToBounds = true
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
        label.textAlignment = .center
        label.contentMode = .center
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionLabelFontSize, style: .bold)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.contentMode = .center
        label.font = UIFont.helveticaNeueFontOfSize(size: Constants.descriptionLabelFontSize, style: .regular)
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .yellow
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(hideCameraScreen), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraManipulationsStackView = CameraManipulationsStackView()
    private var emojiStateButton = RoundedBlurredButton(frame: .zero, blurStyle: .dark)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
        view.backgroundColor = .clear
        
        view.addSubview(cameraPreviewView) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor
        }
        
        newDescriptionLabel.text = LocalizationKeys.new.localized()
        view.addSubview(newDescriptionLabel) {
            $0.top == view.centerYAnchor + Constants.newDescriptionLabelYCenterSpacing
            $0.leading == view.leadingAnchor + Constants.labelSideSpacing
            $0.trailing == view.trailingAnchor - Constants.labelSideSpacing
        }
        
        descriptionLabel.text = LocalizationKeys.pressAndHoldToTryCameraEffects.localized()
        view.addSubview(descriptionLabel) {
            $0.top == newDescriptionLabel.bottomAnchor + Constants.descriptionLabelTopSpacing
            $0.leading == view.leadingAnchor + Constants.labelSideSpacing
            $0.trailing == view.trailingAnchor - Constants.labelSideSpacing
        }
        
        view.addSubview(touchSignImageView) {
            $0.bottom == newDescriptionLabel.topAnchor -  Constants.newDescriptionLabelTopSpacing
            $0.centerX == view.centerXAnchor
            $0.width == view.width / 3.5
            $0.height == view.width / 3.5
        }
        
        view.addSubview(backButton) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor
            $0.width == 40
            $0.height == 40
        }
        
        view.addSubview(cameraManipulationsStackView) {
            $0.top == cameraPreviewView.topAnchor + Constants.cameraManipulationsStackViewSpacing
            $0.trailing == cameraPreviewView.trailingAnchor - Constants.cameraManipulationsStackViewSpacing
            $0.width == Constants.cameraManipulationsStackViewWidth
        }
        cameraManipulationsStackView.delegate = self
        cameraManipulationsStackView.setCurrentOptions(with: [.messages, .gallery, .lightning, .switchCamera])
        
        view.addSubview(emojiStateButton) {
            $0.top == cameraPreviewView.topAnchor + Constants.cameraManipulationsStackViewSpacing
            $0.leading == cameraPreviewView.leadingAnchor + Constants.cameraManipulationsStackViewSpacing
        }
        emojiStateButton.setTitle("\u{1F603} Normal", for: .normal)
        emojiStateButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
    }
}


// MARK: - Selectors
extension CameraScreenViewController {
    @objc func hideCameraScreen() {
        listener?.hideCameraScreen()
    }
}

// MARK: - CameraScreenPresentable
extension CameraScreenViewController: CameraScreenPresentable {
    
    func setup(with previewLayer: AVCaptureVideoPreviewLayer?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cameraPreviewLayer = previewLayer
            if previewLayer != nil {
                self.cameraPreviewLayer.frame = self.cameraPreviewView.layer.bounds
                self.cameraPreviewView.layer.cornerRadius = Constants.cameraLayerCornerRadius
                self.cameraPreviewView.layer.addSublayer(self.cameraPreviewLayer)
            }
            self.newDescriptionLabel.text = previewLayer == nil ?  LocalizationKeys.problemWithYourCamera.localized() : LocalizationKeys.new.localized()
            self.descriptionLabel.text = previewLayer == nil ? "" : LocalizationKeys.pressAndHoldToTryCameraEffects.localized()
        }
    }
    
}

// MARK: - CameraScreenViewControllable
extension CameraScreenViewController: CameraScreenViewControllable {}

// MARK: - CameraManipulationsStackViewDelegate
extension CameraScreenViewController: CameraManipulationsStackViewDelegate {
    func buttonPressed(with manipulationType: CameraManipulationTypes) {
        print(manipulationType.stringDescription)
    }
}
