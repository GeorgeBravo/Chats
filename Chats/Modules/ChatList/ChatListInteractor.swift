// 
//  ChatListInteractor.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatListRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ChatListPresentable: Presentable {
    var listener: ChatListPresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChatListListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ChatListInteractor: PresentableInteractor<ChatListPresentable> {

    weak var router: ChatListRouting?
    weak var listener: ChatListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: ChatListPresentable) {
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

extension ChatListInteractor: ChatListInteractable {}

extension ChatListInteractor: ChatListPresentableListener {}
