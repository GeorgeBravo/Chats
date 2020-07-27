// 
//  ChatListInteractor.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import Foundation

protocol ChatListRouting: ViewableRouting {
    func showChat(of type: ChatType)
    func hideChat()
    
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ChatListPresentable: Presentable {
    var listener: ChatListPresentableListener? { get set }
    func update()
    func setupNoChatsView()
    
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChatListListener: class {
    
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ChatListInteractor: PresentableInteractor<ChatListPresentable> {
    
    weak var router: ChatListRouting?
    weak var listener: ChatListListener?
    
    private var sections: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet {
            presenter.update()
        }
    }
    var favoriteChatListModels = [ChatListTableViewCellModel]()
    var chatListModels = [ChatListTableViewCellModel]()
    override init(presenter: ChatListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        setupChatContent()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: - Private Functions
    private func deleteFavorite(chatIds: [Int]) {
         var modelToDelete: ChatListTableViewCellModel?
         for id in chatIds {
             if favoriteChatListModels.contains(where: { (model) -> Bool in
                 if model.id == id {
                     modelToDelete = model
                     return true
                 }
                 return false
             }) {
                 favoriteChatListModels.removeAll{ $0.id == modelToDelete?.id }
             }
         }
     }
    
    private func setupChatContent() {
        favoriteChatListModels = [
            ChatListTableViewCellModel(title: "", collocutorName: "Alfa Enzo Group Chat", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date(), imageLink: "img2", messageCount: 2, id: 0, isGroupChat: true, lastSender: "You", membersCount: 322000, membersOnline: 1210),
            ChatListTableViewCellModel(title: "", collocutorName: "Angie T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore, imageLink: nil, messageCount: 66, id: 1)
        ]
        
        chatListModels = [
            ChatListTableViewCellModel(title: "", collocutorName: "Misha T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore, imageLink: nil, messageCount: 23, id: 0, isGroupChat: true, lastSender: "Sava"),
            ChatListTableViewCellModel(title: "", collocutorName: "Lena T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 5, id: 2),
            ChatListTableViewCellModel(title: "", collocutorName: "Natalia T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 7, id: 3),
            ChatListTableViewCellModel(title: "", collocutorName: "Dmitriy T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 55, id: 4, isGroupChat: true, lastSender: "Mishalaka"),
            ChatListTableViewCellModel(title: "", collocutorName: "Susana T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 99, id: 5, isGroupChat: true, lastSender: "Lisa"),
            ChatListTableViewCellModel(title: "", collocutorName: "Susana T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 1, id: 6)
        ]
    }
    
    private func deleteChatsList(chatIds: [Int]) {
         var modelToDelete: ChatListTableViewCellModel?
         for id in chatIds {
             if chatListModels.contains(where: { (model) -> Bool in
                 if model.id == id {
                     modelToDelete = model
                     return true
                 }
                 return false
             }) {
                 chatListModels.removeAll{ $0.id == modelToDelete?.id }
             }
         }
     }
}

extension ChatListInteractor: ChatListInteractable {
    
    func showChat(of type: ChatType) {
        router?.showChat(of: type)
    }
    
    // MARK: - Chat Listener
    func hideChat() {
        router?.hideChat()
    }
}

extension ChatListInteractor: ChatListPresentableListener {
    func setupContent() {
        setupChatContent()
    }
    
    func deleteChats(chatIds: [Int]) {
        deleteFavorite(chatIds: chatIds)
        deleteChatsList(chatIds: chatIds)
        combineChatListSections()
        if favoriteChatListModels.isEmpty && chatListModels.isEmpty {
            presenter.setupNoChatsView()
        }
    }
    
    func combineChatListSections() {
        
        if favoriteChatListModels.isEmpty && !chatListModels.isEmpty {
            let secondSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "CHATS", cellModels: chatListModels)
            sections = [secondSection]
        }
        
        if !favoriteChatListModels.isEmpty && chatListModels.isEmpty {
            let firstSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "FAVORITES", cellModels: favoriteChatListModels)
            sections = [firstSection]
        }
        
        if favoriteChatListModels.isEmpty && chatListModels.isEmpty {
            sections.removeAll()
        }
        
        if !favoriteChatListModels.isEmpty && !chatListModels.isEmpty {
            let firstSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "FAVORITES", cellModels: favoriteChatListModels)
            let secondSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "CHATS", cellModels: chatListModels)
            sections = [firstSection, secondSection]
        }
    }
    
    func cellForRow(at indexPath: IndexPath) -> TableViewCellModel {
        let section = indexPath.section
        let row = indexPath.row
        return sections[section].cellModels[row]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections[section].cellModels.count
    }
    
    func numberOfSection() -> Int {
        return sections.count
    }
    
    func sectionModel(for number: Int) -> TableViewSectionModel {
        return sections[number]
    }
}
