//
//  ButtonLabelStackView.swift
//  Chats
//
//  Created by user on 24.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit

private struct Constants {
    static let height: CGFloat = 56
    static let buttonFrame: CGRect = CGRect(0.0, 0.0, height, height)
    static let spacing: CGFloat = 8.0
}

protocol ButtonLabelStackViewDelegate: class {
    func buttonPressed(with option: CollocutorOptionType)
}

class ButtonLabelStackView: UIStackView {
    
    // MARK: - Variables
    weak var delegate: ButtonLabelStackViewDelegate?
    private var manipulation: CollocutorOptionType?
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(named: .paleGray)
        button.clipsToBounds = true
        button.layer.cornerRadius = Constants.height / 2
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: .blueGray)
        return label
    }()
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(manipulation: CollocutorOptionType) {
        self.manipulation = manipulation
        actionLabel.text = manipulation.stringDescription.lowercased()
        guard let image = manipulation.optionImage else { return }
        actionButton.setImage(image, for: .normal)
    }
    
}

extension ButtonLabelStackView {
    func setupViews() {
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = Constants.spacing
        
        addSubview(actionButton) {
            $0.width == Constants.height
            $0.height == Constants.height
        }
        addArrangedSubview(actionButton)
        
        addSubview(actionLabel)
        addArrangedSubview(actionLabel)
    }
}

// MARK: - Selectors
extension ButtonLabelStackView {
    @objc func buttonPressed(_ sender: UIButton) {
        guard let manipulation = manipulation else { return }
        delegate?.buttonPressed(with: manipulation)
    }
}
