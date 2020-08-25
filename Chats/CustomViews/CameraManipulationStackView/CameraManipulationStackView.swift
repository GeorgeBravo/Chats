//
//  CameraManipulationStackView.swift
//  Chats
//
//  Created by user on 19.08.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

class CameraManipulationStackView: UIStackView {
    
    // MARK: - UI Variables
    private var sendMessageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var galletyButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var lightningButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var switchCameraButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Logic
    
    
}
