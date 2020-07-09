//
//  CollocutorManipulationsButtonsView.swift
//  Chats
//
//  Created by user on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let height: CGFloat = 32.0
    static let buttonFrame: CGRect = CGRect(0.0, 0.0, height, height)
}

enum CollocutorManipulations: Int {
    case call
    case search
    case mute
    case more
    
    var stringDescription: String {
        switch self {
        case .call: return LocalizationKeys.call.localized()
        case .search: return LocalizationKeys.search.localized()
        case .mute: return LocalizationKeys.mute.localized()
        case .more: return LocalizationKeys.more.localized()
        }
    }
}

protocol CollocutorManipulationsButtonsStackViewDelegate: class {
    func buttonPressed(with action: CollocutorManipulations)
}

class CollocutorManipulationsButtonsStackView: UIStackView {
    
    // MARK: - Variables
    weak var delegate: CollocutorManipulationsButtonsStackViewDelegate?
    
    private lazy var callButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = #imageLiteral(resourceName: "call")
        button.backgroundColor = .clear
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = #imageLiteral(resourceName: "search")
        button.backgroundColor = .clear
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var muteButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "mute")
        button.backgroundColor = .clear
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreOptionsButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "more")
        button.backgroundColor = .clear
        button.setBackgroundImage(image, for: .normal)
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
    
}

extension CollocutorManipulationsButtonsStackView {
    func setupViews() {
        heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        var tag = 0
        [callButton, searchButton, muteButton, moreOptionsButton].forEach {
            $0.tag = tag
            addSubview($0) {
                $0.width == Constants.height
                $0.height == Constants.height
            }
            tag += 1
            addArrangedSubview($0)
        }
    }
}

// MARK: - Selectors
extension CollocutorManipulationsButtonsStackView {
    @objc func buttonPressed(_ sender: UIButton) {
        guard let manipulation = CollocutorManipulations(rawValue: sender.tag) else { return }
        delegate?.buttonPressed(with: manipulation)
    }
}
