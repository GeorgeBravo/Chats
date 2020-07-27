//
//  RootInteractor.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck

protocol RootRouting: LaunchRouting {
    func showChatList()
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }

    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class RootInteractor: PresentableInteractor<RootPresentable> {
    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        router?.showChatList()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }
}

extension RootInteractor: RootPresentableListener {}

extension RootInteractor: RootInteractable {}
