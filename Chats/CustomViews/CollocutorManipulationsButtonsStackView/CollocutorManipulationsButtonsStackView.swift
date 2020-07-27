//
//  CollocutorManipulationsButtonsView.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
//    static let height: CGFloat = 56
//    static let buttonFrame: CGRect = CGRect(0.0, 0.0, height, height)
}

protocol CollocutorManipulationsButtonsStackViewDelegate: class {
    func buttonPressed(with action: CollocutorOptionType)
}

class CollocutorManipulationsButtonsStackView: UIStackView {
    
    // MARK: - Variables
    weak var delegate: CollocutorManipulationsButtonsStackViewDelegate?
    
    private lazy var callButtonLabelStackView: ButtonLabelStackView = {
        let buttonLabelStackView = ButtonLabelStackView()
        buttonLabelStackView.clipsToBounds = true
        return buttonLabelStackView
    }()
    
    private lazy var searchButtonLabelStackView: ButtonLabelStackView = {
        let buttonLabelStackView = ButtonLabelStackView()
        buttonLabelStackView.clipsToBounds = true
        return buttonLabelStackView
    }()
    
    private lazy var muteButtonLabelStackView: ButtonLabelStackView = {
        let buttonLabelStackView = ButtonLabelStackView()
        buttonLabelStackView.clipsToBounds = true
        return buttonLabelStackView
    }()
    
    private lazy var moreOptionsButtonLabelStackView: ButtonLabelStackView = {
        let buttonLabelStackView = ButtonLabelStackView()
        buttonLabelStackView.clipsToBounds = true
        return buttonLabelStackView
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollocutorManipulationsButtonsStackView {
    func setupViews() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        var tag = 0
        
        [callButtonLabelStackView, searchButtonLabelStackView, muteButtonLabelStackView, moreOptionsButtonLabelStackView].forEach {
            addSubview($0)
            $0.setupWith(manipulation: CollocutorOptionType(rawValue: tag) ?? .addToContacts)
            $0.delegate = self
            tag += 1
            addArrangedSubview($0)
        }
    }
}

// MARK: - ButtonLabelStackViewDelegate
extension CollocutorManipulationsButtonsStackView: ButtonLabelStackViewDelegate {
    func buttonPressed(with option: CollocutorOptionType) {
        delegate?.buttonPressed(with: option)
    }
}
