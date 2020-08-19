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
    
    func showCameraScreen()
    func hideCameraScreen()
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ThreadsChatListViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Variables
    private var cameraButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(goToCameraScreen), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    weak var listener: ThreadsChatListPresentableListener?
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    // MARK: - Setup Views Logic
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(cameraButton) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor
            $0.width == 40
            $0.height == 40
        }
    }
}

// MARK: - Selectors
extension ThreadsChatListViewController {
    @objc func goToCameraScreen() {
        listener?.showCameraScreen()
    }
}

// MARK: - ThreadsChatListPresentable
extension ThreadsChatListViewController: ThreadsChatListPresentable {}

// MARK: - ThreadsChatListViewControllable
extension ThreadsChatListViewController: ThreadsChatListViewControllable {}
