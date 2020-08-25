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
    private var navigationBar: NewCustomChatListNavigationView = {
        let view = NewCustomChatListNavigationView()
        return view
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
        let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(incrementProgress), userInfo: nil, repeats: true)
    }
    
    // MARK: - Setup Views Logic
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBar) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor
            $0.height == 60
        }
        navigationBar.delegate = self
    }
    
    @objc func incrementProgress() {
        navigationBar.cameraButton.progress += 0.01
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

// MARK: - NewCustomChatListNavigationViewDelegate
extension ThreadsChatListViewController: NewCustomChatListNavigationViewDelegate {
    func pencilButtonTapped() {
        
    }
    
    func avatarButtonTapped() {
        
    }
    
    func cameraButtonTapped() {
        goToCameraScreen()
    }
}
