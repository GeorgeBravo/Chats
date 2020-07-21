// 
//  ChatRouter.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck

protocol ChatInteractable: Interactable, CollocutorProfileListener, GroupProfileListener, MessageManipulationListener {
    var router: ChatRouting? { get set }
    var listener: ChatListener? { get set }
}

protocol ChatViewControllable: ViewControllable {

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChatRouter: ViewableRouter<ChatInteractable, ChatViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.

    init(interactor: ChatInteractable,
         viewController: ChatViewControllable,
         _ collocutorProfileBuilder: CollocutorProfileBuildable,
         _ groupProfileBuilder: GroupProfileBuildable,
         _ messageManipulationBuilder: MessageManipulationBuildable) {
        self.collocutorProfileBuilder = collocutorProfileBuilder
        self.groupProfileBuilder = groupProfileBuilder
        self.messageManipulationBuilder = messageManipulationBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - CollocutorProfile
    private var collocutorProfileBuilder: CollocutorProfileBuildable
    private var collocutorProfileRouter: ViewableRouting?
    
    // MARK: - Group Profile
    private var groupProfileBuilder: GroupProfileBuildable
    private var groupProfileRouter: ViewableRouting?
    
    // MARK: - Message Manipulation
    private var messageManipulationBuilder: MessageManipulationBuildable
    private var messageManipulationRouter: ViewableRouting?
}

extension ChatRouter: ChatRouting {
    
    func showUser(with profile: Collocutor) {
        let collocutorProfileRouter = collocutorProfileBuilder.build(withListener: interactor, profile: profile)
        self.collocutorProfileRouter = collocutorProfileRouter

        attach(collocutorProfileRouter)
        
        presentModally(collocutorProfileRouter, animated: true, embedInNavigationController: true)
    }
    
    func showGroupProfile() {
        let groupProfileRouter = groupProfileBuilder.build(withListener: interactor)
        self.groupProfileRouter = groupProfileRouter
        
        attach(groupProfileRouter)
        presentModally(groupProfileRouter, animated: true, embedInNavigationController: true)
    }
    
    func showMessageManipulation(with chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues) {
        let messageManipulationRouter = messageManipulationBuilder.build(withListener: interactor, chatTableViewCellModel: chatTableViewCellModel, cellNewFrame: cellNewFrame)
        self.messageManipulationRouter = messageManipulationRouter
        
        attach(messageManipulationRouter)
        present(messageManipulationRouter, animated: false, embedInNavigationController: false, modalPresentationStyle: .overCurrentContext)
    }
    
    func hideUser() {
        guard let collocutorProfileRouter = collocutorProfileRouter else { return }

        detach(collocutorProfileRouter)
        collocutorProfileRouter.dismiss(animated: true)
        self.collocutorProfileRouter = nil
    }
    
    func hideGroup() {
        guard let groupProfileRouter = groupProfileRouter else { return }
        
        detach(groupProfileRouter)
        groupProfileRouter.dismiss(animated: true)
        self.groupProfileRouter = nil
    }
    
    func hideMessageManipulation() {
        guard let messageManipulationRouter = messageManipulationRouter else { return }
        
        detach(messageManipulationRouter)
        messageManipulationRouter.dismiss(animated: false)
        self.messageManipulationRouter = nil
    }
    
}
