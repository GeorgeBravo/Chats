// 
//  ChatInteractor.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import UIKit

protocol ChatRouting: ViewableRouting {

    func showUser(with profile: Collocutor)
    func showGroupProfile()
    func showMessageManipulation(with chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues)
    func hideUser()
    func hideGroup()
    func hideMessageManipulation(completion: @escaping () -> Void)
    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol ChatPresentable: Presentable {
    var listener: ChatPresentableListener? { get set }

    func execute(messageManipulationType: MessageManipulationType, chatTableViewCellModel: ChatContentTableViewCellModel)
    func showPinnedMessage(mockMessage: MockMessage)
    func hidePinnedMessage()
    
    func onNewMessage(_ message: MockMessage)
    func onTypingStatus()
    
    func reloadTableView()
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChatListener: class {

    func hideChat()
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class ChatInteractor: PresentableInteractor<ChatPresentable> {

    weak var router: ChatRouting?
    weak var listener: ChatListener?
    
    public var messageList: [MockMessage] = [] {
        didSet { messageListDidChange() }
    }
    
    private var sections: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet {
            self.presenter.reloadTableView()
        }
    }
    
    private var currentlyHiddenMessageId: String? {
        didSet {
            if currentlyHiddenMessageId != nil { messageListDidChange() }
        }
    }

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
    
    // MARK: - Private
    
    func hideMessageManipulation(_ manipulationType: MessageManipulationType?, chatTableViewCellModel: ChatContentTableViewCellModel?) {
        showAllMessages()
        router?.hideMessageManipulation { [weak self] in
            if let self = self, let manipulationType = manipulationType, let chatTVCellModel = chatTableViewCellModel {
                switch manipulationType {
                case .pin, .unpin:
                    self.askAboutPinUnpinMessage(chatTVCellModel: chatTVCellModel)
                default:
                    self.presenter.execute(messageManipulationType: manipulationType, chatTableViewCellModel: chatTVCellModel)
                }
            }
        }
    }
    
    private func showAllMessages() {
        currentlyHiddenMessageId = nil
        for (index, _) in messageList.enumerated() {
            messageList[index].setNeedHideMessage(false)
        }
    }
    
    private func showSelectedMessageManipulations(chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: CGRect) {
        let frameValues = FrameValues(xPositionValue: cellNewFrame.minX, yPositionValue: cellNewFrame.minY, heightValue: cellNewFrame.height, widthValue: cellNewFrame.width)
        showMessageManipulation(with: chatTableViewCellModel, cellNewFrame: frameValues)
    }
    
    private func askAboutPinUnpinMessage(chatTVCellModel: ChatContentTableViewCellModel) {
        for (index, item) in self.messageList.enumerated() {
            if item.messageId == chatTVCellModel.messageId {
                if !self.messageList[index].isPinned {
                    self.presenter.showPinnedMessage(mockMessage: item)
                } else {
                    self.presenter.hidePinnedMessage()
                }
            }
        }
    }
    
    func updateMessageListAfterPinUnpin(mockMessage: MockMessage) {
        for (index, item) in self.messageList.enumerated() {
            if item.messageId == mockMessage.messageId {
                self.messageList[index].isPinned = !self.messageList[index].isPinned
            } else {
                self.messageList[index].isPinned = false
            }
        }
    }
}

// MARK: - Data Source Sort
extension ChatInteractor {
    private func messageListDidChange() {
        let sortedViewModels = groupSort(items: messageList, isAscending: true)
        
        let sections: [TableViewSectionModel] = sortedViewModels.map {
            let oldestMessageDate = $0.first?.timestamp
            return ChatTableViewSectionModel(headerViewType: .messagesTimestamp, title: oldestMessageDate?.headerSectionDate ?? "Unknown date", cellModels: $0, headerStyle: .bubble)
        }.compactMap { $0 }
        
        self.sections = sections
    }
    
    private func groupSort(items: [ChatScreenDisplayingItems], isAscending: Bool) -> [[ChatTableViewCellModel]] {
        var groups = [[ChatScreenDisplayingItems]]()
        items.forEach { (item) in
            let groupIndex = groups.firstIndex(where: { (group) -> Bool in
                let isContains = group.contains(where: { (groupItem) -> Bool in
                    Calendar.current.isDate(groupItem.sentDate, inSameDayAs: item.sentDate)
                })
                return isContains
            })
            if let groupIndex = groupIndex {
                var group = groups[groupIndex]
                let nextIndex = group.firstIndex(where: { (groupItem) -> Bool in
                    groupItem.sentDate.compare(item.sentDate) == (isAscending ? .orderedDescending : .orderedAscending )
                })
                if let nextIndex = nextIndex {
                    group.insert(item, at: nextIndex)
                } else {
                    group.append(item)
                }
                groups[groupIndex] = group
            } else {
                let nextIndex = groups.firstIndex(where: { (group) -> Bool in
                    group[0].sentDate.compare(item.sentDate) == (isAscending ? .orderedDescending : .orderedAscending)
                })
                if let nextIndex = nextIndex {
                    groups.insert([item], at: nextIndex)
                } else {
                    groups.append([item])
                }
            }
        }
        
        return groups.compactMap {
            $0.compactMap { [weak self] item in
                guard let self = self, var mockMessage = item as? MockMessage else { return nil }
                
                if let currentlyHiddenMessageId = self.currentlyHiddenMessageId {
                    mockMessage.setNeedHideMessage(currentlyHiddenMessageId == mockMessage.messageId)
                }
                
                if var model = mockMessage.tableViewCellViewModel as? ChatContentTableViewCellModel {
                    model.messageSelection = { [weak self] chatTableViewCellModel, cellNewFrame in
                        self?.showSelectedMessageManipulations(chatTableViewCellModel: chatTableViewCellModel, cellNewFrame: cellNewFrame)
                        self?.currentlyHiddenMessageId = mockMessage.messageId
                    }
                    return model
                } else {
                    return mockMessage.tableViewCellViewModel
                }
            }
            
        }
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
}

extension ChatInteractor: ChatPresentableListener {
    
    // MARK: - Data Source
    func cellModelForRow(at indexPath: IndexPath) -> TableViewCellModel {
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
    
    func getIndexPath(for message: MockMessage) -> IndexPath? {
        var sectionIndex = 0
        for section in sections {
            var msgRow = 0
            for msg in section.cellModels {
                if message.messageId == (msg as? ChatContentTableViewCellModel)?.messageId {
                    let destinationIndexPath = IndexPath(row: msgRow, section: sectionIndex)
                    return destinationIndexPath
                }
                msgRow += 1
            }
            sectionIndex += 1
        }
        return nil
    }

    // MARK: - Mock Socket
    
    func connectMockSocket(with chatType: ChatType) {
        MockSocket.shared.connect(with: chatType)
            .onTypingStatus { [weak self] in
                self?.presenter.onTypingStatus()
                
        }.onNewMessage { [weak self] message in
            UIView.animate(withDuration: 0.1, animations: {
                self?.messageList.append(message)
                self?.presenter.onNewMessage(message)
            }, completion: nil)
        }
    }
    
    func disconnectMockSocket() {
        MockSocket.shared.disconnect()
    }
    
    // MARK: - Routing
    
    func showUser(with profile: Collocutor) {
        router?.showUser(with: profile)
    }
    
    func showGroupProfile() {
        router?.showGroupProfile()
    }
    
    func hideChat() {
        listener?.hideChat()
    }
    
    func unpinnedAllMessages() {
        for (index, _) in self.messageList.enumerated() {
            self.messageList[index].isPinned = false
        }
    }
    
    func showMessageManipulation(with chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues) {
        router?.showMessageManipulation(with: chatTableViewCellModel, cellNewFrame: cellNewFrame)
    }
}
