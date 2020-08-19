// 
//  ThreadsChatListViewController.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

protocol ThreadsChatListPresentableListener: class {
    
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ThreadsChatListViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var listener: ThreadsChatListPresentableListener?
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
    }
}

extension ThreadsChatListViewController: ThreadsChatListPresentable {}

extension ThreadsChatListViewController: ThreadsChatListViewControllable {}
