// 
//  ThreadsChatInteractor.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ThreadsChatRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ThreadsChatPresentable: Presentable {
    var listener: ThreadsChatPresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ThreadsChatListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ThreadsChatInteractor: PresentableInteractor<ThreadsChatPresentable> {

    weak var router: ThreadsChatRouting?
    weak var listener: ThreadsChatListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: ThreadsChatPresentable) {
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

extension ThreadsChatInteractor: ThreadsChatInteractable {}

extension ThreadsChatInteractor: ThreadsChatPresentableListener {}
