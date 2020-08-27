//
//  CameraManipulationsStackView.swift
//  Chats
//
//  Created by user on 19.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

enum CameraManipulationTypes: Int {
    case gallery
    case lightning
    case messages
    case switchCamera
    
    var manipulationIcon: UIImage {
        switch self {
        default: return #imageLiteral(resourceName: "search")
        }
    }
    
    var stringDescription: String {
        switch self {
        case .gallery: return "gallery"
        case .lightning: return "lightning"
        case .messages: return "messages"
        case .switchCamera: return "switchCamera"
        }
    }
}

private struct Constants {
    static let stackViewSpacing: CGFloat = 8.0
}

protocol CameraManipulationsStackViewDelegate: class {
    func buttonPressed(with manipulationType: CameraManipulationTypes)
}

class CameraManipulationsStackView: UIStackView {
    
    // MARK: - Variables
    private var currentOptions = [CameraManipulationTypes]()
    weak var delegate: CameraManipulationsStackViewDelegate?
    
    // MARK: - UI Variables
    private lazy var messagesButton: RoundedBlurredButton = {
        let button = RoundedBlurredButton(frame: .zero)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var galleryButton: RoundedBlurredButton = {
        let button = RoundedBlurredButton(frame: .zero)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lightningButton: RoundedBlurredButton = {
        let button = RoundedBlurredButton(frame: .zero)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchCameraButton: RoundedBlurredButton = {
        let button = RoundedBlurredButton(frame: .zero)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Logic
    func setCurrentOptions(with options: [CameraManipulationTypes]) {
        for (index, subview) in arrangedSubviews.enumerated() {
            subview.tag = 0
            if !options.contains(currentOptions[index]) {
                subview.removeAllConstraints()
                subview.removeFromSuperview()
            }
        }
        currentOptions = options
        for (index, option) in currentOptions.enumerated() {
            switch option {
            case .gallery: addButtonToStackView(button: galleryButton, tag: index)
            case .lightning: addButtonToStackView(button: lightningButton, tag: index)
            case .messages: addButtonToStackView(button: messagesButton, tag: index)
            case .switchCamera: addButtonToStackView(button: switchCameraButton, tag: index)
            }
        }
    }
    
}

// MARK: - Setup UI
extension CameraManipulationsStackView {
    
    private func setupViews() {
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = Constants.stackViewSpacing
    }
    
    private func addButtonToStackView(button: UIButton, tag: Int) {
        button.tag = tag
        button.setImage(currentOptions[tag].manipulationIcon, for: .normal)
        if !arrangedSubviews.contains(button) {
            insertArrangedSubview(button, at: tag)
            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1.0).isActive = true
        }
    }
    
}

// MARK: - Selectors
extension CameraManipulationsStackView {
    @objc private func buttonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(with: currentOptions[sender.tag])
    }
}
