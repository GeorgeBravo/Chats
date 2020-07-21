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
    func showGroupProfile()
    func showMessageManipulation(with chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: FrameValues)
    func hideUser()
    func hideGroup()
    func hideMessageManipulation(completion: @escaping () -> Void)
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ChatPresentable: Presentable {
    var listener: ChatPresentableListener? { get set }

    func showAllMessages()
    func execute(messageManipulationType: MessageManipulationType)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChatListener: class {

    func hideChat()
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
    
    func hideGroupProfile() {
        router?.hideGroup()
    }
    
    func hideMessageManipulation(_ manipulationType: MessageManipulationType?) {
        presenter.showAllMessages()
        router?.hideMessageManipulation { [weak self] in
            if let self = self, let manipulationType = manipulationType {
                self.presenter.execute(messageManipulationType: manipulationType)
            }
        }
    }
    
}

extension ChatInteractor: ChatPresentableListener {

    func showUser(with profile: Collocutor) {
        router?.showUser(with: profile)
    }
    
    func showGroupProfile() {
        router?.showGroupProfile()
    }
    
    func hideChat() {
        listener?.hideChat()
    }
    
    func showMessageManipulation(with chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: FrameValues) {
        router?.showMessageManipulation(with: chatTableViewCellModel, cellNewFrame: cellNewFrame)
    }
}
