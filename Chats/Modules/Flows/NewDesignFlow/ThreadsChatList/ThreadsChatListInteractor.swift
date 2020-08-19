// 
//  ThreadsChatListInteractor.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatListRouting: ViewableRouting {

    func showCameraScreen()
    func hideCameraScreen()
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ThreadsChatListPresentable: Presentable {
    var listener: ThreadsChatListPresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ThreadsChatListListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ThreadsChatListInteractor: PresentableInteractor<ThreadsChatListPresentable> {

    weak var router: ThreadsChatListRouting?
    weak var listener: ThreadsChatListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: ThreadsChatListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }
}

// MARK: - ThreadsChatListInteractable
extension ThreadsChatListInteractor: ThreadsChatListInteractable {}

// MARK: - ThreadsChatListPresentableListener
extension ThreadsChatListInteractor: ThreadsChatListPresentableListener {
    func showCameraScreen() {
        router?.showCameraScreen()
    }
    
    func hideCameraScreen() {
        router?.hideCameraScreen()
    }
}
