// 
//  ChatInteractor.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatRouting: ViewableRouting {

    func showUser(with profile: Collocutor)
    func hideUser()
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ChatPresentable: Presentable {
    var listener: ChatPresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChatListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ChatInteractor: PresentableInteractor<ChatPresentable> {

    weak var router: ChatRouting?
    weak var listener: ChatListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: ChatPresentable) {
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

extension ChatInteractor: ChatInteractable {
    
    // MARK: - Collocutor Profile Listener
    func hideCollocutorProfile() {
        router?.hideUser()
    }
    
}

extension ChatInteractor: ChatPresentableListener {

    func showUser(with profile: Collocutor) {
        router?.showUser(with: profile)
    }
    
}
