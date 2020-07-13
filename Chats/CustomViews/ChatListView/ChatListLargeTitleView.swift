//
//  ChatListLargeTitleView.swift
//  Chats
//
//  Created by Mykhailo H on 7/8/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit


protocol ChatListLargeTitleViewProtocol: class {
    func editAction()
}

class ChatListLargeTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properites
    
    var delegate: ChatListLargeTitleViewProtocol?
    
    //MARK: - Views
    
    fileprivate lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.7, weight: .regular)
        return button
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for messages or users"
        searchBar.layer.cornerRadius = 20
        searchBar.backgroundColor = UIColor(named: ColorName.coolGreyTwo)
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor(named: ColorName.coolGreyTwo).cgColor
        searchBar.layer.borderWidth = 1
        
        let offset = UIOffset(horizontal: 50, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.backgroundColor = UIColor(named: ColorName.coolGreyTwo)
            searchField.textAlignment = .center
            searchField.font = UIFont(name: "HelveticaNeue", size: 16.7)
        }
        return searchBar
    }()
    
    fileprivate lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = UIColor.darkText
        label.numberOfLines = 1
        label.text = "Chats"
        return label
    }()
    
    fileprivate lazy var newChatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "newChatIcon"), for: .normal)
        return button
    }()
    
    //MARK: - Functions
    func addActions() {
        editButton.addTarget(self, action: #selector(onEditButton), for: .touchUpInside)
    }
    
    @objc func onEditButton() {
        delegate?.editAction()
    }
}


extension ChatListLargeTitleView {
    
    private func setupViews() {
        
        backgroundColor = UIColor.clear
        
        addSubview(editButton) {
            $0.leading == leadingAnchor + 19
            $0.top == topAnchor + 21
            $0.height == 17
            $0.width <= 30
        }
        
        addSubview(searchBar) {
            $0.leading == leadingAnchor + 14
            $0.top == editButton.bottomAnchor + 16
            $0.height == 50
            $0.trailing == trailingAnchor - 14
        }
        
        addSubview(newChatButton) {
            $0.width == 35.7
            $0.height == 34
            $0.top == searchBar.bottomAnchor + 25
            $0.trailing == trailingAnchor - 24
        }
        
        addSubview(titleLabel) {
            $0.leading == leadingAnchor + 17
            $0.top == searchBar.bottomAnchor + 25
            $0.trailing == newChatButton.leadingAnchor - 20
            $0.height == 30
        }
    }
}
