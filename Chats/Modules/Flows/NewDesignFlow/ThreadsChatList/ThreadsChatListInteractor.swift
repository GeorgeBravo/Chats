// 
//  ThreadsChatListInteractor.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import UIKit

protocol ThreadsChatListRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ThreadsChatListPresentable: Presentable {
    var listener: ThreadsChatListPresentableListener? { get set }
    func update()
    func setupNoChatsView()
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ThreadsChatListListener: class {

    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ThreadsChatListInteractor: PresentableInteractor<ThreadsChatListPresentable> {

    weak var router: ThreadsChatListRouting?
    weak var listener: ThreadsChatListListener?

    private var sections: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet {
            presenter.update()
        }
    }
    var favoriteChatListModels = [ThreadsChatListTableViewCellModel]()
    var chatListModels = [ThreadsChatListTableViewCellModel]()
    override init(presenter: ThreadsChatListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        setupChatContent()
    }
    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.
    }
    
    private func setupChatContent() {
        favoriteChatListModels = [
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Tony Tran", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date(), imageLink: "img2", messageCount: 2, id: 12313123, isGroupChat: false, isOnline: true, hasStory: false),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Quyen Phan", message: "Mentioned you in their story" , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 0, id: 1, hasStory: true),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Johny B. Goode", message: "Okay cool, let's rock n roll!" , timeSent: "3.00 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore, imageLink: "Dan-Leonard", messageCount: 0, id: 100, isGroupChat: false)
        ]
        
        chatListModels = [
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Elon Must", message: "We must wake up for a fut..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore, imageLink: nil, messageCount: 2, id: 0, isGroupChat: false),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "AEF Group Chat", message: "Okay got it, TY!", timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 5, id: 2, isGroupChat: true, lastSender: "You"),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Natalia T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 7, id: 3),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Dmitriy T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 55, id: 4, isGroupChat: true, lastSender: "Mishalaka"),
            ThreadsChatListTableViewCellModel(title: "", collocutorName: "Susana T. Trinh", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", sentDate: Date().dayBefore.dayBefore.dayBefore.dayBefore.dayBefore.dayBefore, imageLink: nil, messageCount: 99, id: 5, isGroupChat: true, lastSender: "Lisa")
        ]
    }
}

extension ThreadsChatListInteractor: ThreadsChatListInteractable {}

extension ThreadsChatListInteractor: ThreadsChatListPresentableListener {
    func combineChatListSections() {
        let firstSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "", cellModels: favoriteChatListModels)
        let secondSection = ChatListTableViewSectionModel(headerViewType: .chatList, title: "CHATS", cellModels: chatListModels)
        sections = [firstSection, secondSection]
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
    
    func getChatListTableViewCellModelForRow(indexPath: IndexPath) -> ThreadsChatListTableViewCellModel {
        return favoriteChatListModels[indexPath.row]
    }
}
