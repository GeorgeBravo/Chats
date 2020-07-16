// 
//  ChatListRouter.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatListInteractable: Interactable, ChatListener {
    var router: ChatListRouting? { get set }
    var listener: ChatListListener? { get set }
}

protocol ChatListViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChatListRouter: ViewableRouter<ChatListInteractable, ChatListViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    init(interactor: ChatListInteractable,
         viewController: ChatListViewControllable,
         _ chatBuilder: ChatBuildable) {
        self.chatBuilder = chatBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    // MARK: - Chat
    private var chatBuilder: ChatBuildable
    private var chatRouter: ViewableRouting?
}

extension ChatListRouter: ChatListRouting {
    func showChat() {
        let chatRouter = chatBuilder.build(withListener: interactor)
        self.chatRouter = chatRouter

        attach(chatRouter)
        present(chatRouter, animated: true, embedInNavigationController: true, completion: nil)
//        pushRouter(chatRouter, animated: true)
    }
    
    func hideChat() {
        guard let chatRouter = chatRouter else {
            return
        }

        detach(chatRouter)
        chatRouter.dismiss(animated: true)
//        chatRouter.popRouter(animated: true)
        self.chatRouter = nil
    }
}
