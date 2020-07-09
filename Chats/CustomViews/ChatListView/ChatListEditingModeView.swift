//
//  ChatListEditingModeView.swift
//  Chats
//
//  Created by Mykhailo H on 7/9/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

protocol ChatListEditingModeViewProtocol: class {
    func readAll()
    func archive()
    func delete()
}

class ChatListEditingModeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properites
    var delegate: ChatListEditingModeViewProtocol?
    
    //MARK: - Views
    
    fileprivate lazy var readAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .disabled)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.7, weight: .medium)
        return button
    }()
    fileprivate lazy var archiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Archive", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .disabled)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.7, weight: .medium)
        return button
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .disabled)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.7, weight: .medium)
        return button
    }()
    
    //MARK: - Private Functions
    private func addActions() {
        readAllButton.addTarget(self, action: #selector(readAllButtonTapped), for: .touchUpInside)
        archiveButton.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Objc func
    @objc func readAllButtonTapped() {
        delegate?.readAll()
    }
    @objc func archiveButtonTapped() {
        delegate?.archive()
    }
    @objc func deleteButtonTapped() {
        delegate?.delete()
    }
}


extension ChatListEditingModeView {
    
    private func setupViews() {
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: ColorName.optionsBlackColor).cgColor
        
        addSubview(readAllButton) {
            $0.leading == leadingAnchor + 25
            $0.top == topAnchor + 12.7
            $0.height == 14
            $0.width == 70
        }
        
        addSubview(archiveButton) {
            $0.top == topAnchor + 12.7
            $0.height == 14
            $0.width == 70
            $0.centerX == centerXAnchor
        }
        
        addSubview(deleteButton) {
            $0.trailing == trailingAnchor - 25
            $0.top == topAnchor + 12.7
            $0.height == 14
            $0.width == 70
        }
    }
}
