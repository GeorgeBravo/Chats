// 
//  MessageManipulationInteractor.swift
//  Chats
//
//  Created by user on 20.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import Foundation

protocol MessageManipulationRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol MessageManipulationPresentable: Presentable {
    var listener: MessageManipulationPresentableListener? { get set }
    
    func update()
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MessageManipulationListener: class {

    func hideMessageManipulation(_ manipulationType: MessageManipulationType?)
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class MessageManipulationInteractor: PresentableInteractor<MessageManipulationPresentable> {

    weak var router: MessageManipulationRouting?
    weak var listener: MessageManipulationListener?
    private var cellNewFrame: FrameValues
    private var sectionModels: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet {
            presenter.update()
        }
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    init(presenter: MessageManipulationPresentable, chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: FrameValues) {
        self.cellNewFrame = cellNewFrame
        super.init(presenter: presenter)
        presenter.listener = self
        var newChatTableViewCellModel = chatTableViewCellModel
        newChatTableViewCellModel.messageSelection = nil
        let section = MessageManipulationTableViewSectionModel(title: "", cellModels: [newChatTableViewCellModel], widthConstant: 0.0, heightConstant: 0.0, fillColorName: nil)
        sectionModels.append(section)
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

extension MessageManipulationInteractor: MessageManipulationInteractable {}

extension MessageManipulationInteractor: MessageManipulationPresentableListener {
    func hideMessageManipulation() {
        listener?.hideMessageManipulation(nil)
    }
    
    func numberOfSections() -> Int {
        return sectionModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sectionModels[section].cellModels.count
    }
    
    func cellModelForRow(at indexPath: IndexPath) -> TableViewCellModel {
        return sectionModels[indexPath.section].cellModels[indexPath.row]
    }
    
    func sectionModel(for section: Int) -> TableViewSectionModel {
        return sectionModels[section]
    }
    
    func cellOffsetFrame() -> FrameValues {
        return cellNewFrame
    }
    
    func addOptions() {
        let answerOption = MessageManipulationTableViewCellModel(messageManipulationType: .answer, isFirstOption: true)
        let copyOption = MessageManipulationTableViewCellModel(messageManipulationType: .copy)
        let changeOption = MessageManipulationTableViewCellModel(messageManipulationType: .change)
        let pinOption = MessageManipulationTableViewCellModel(messageManipulationType: .pin)
        let forwardOption = MessageManipulationTableViewCellModel(messageManipulationType: .forward)
        let replyOption = MessageManipulationTableViewCellModel(messageManipulationType: .reply)
        let firstOptionSection = MessageManipulationTableViewSectionModel(title: "", cellModels: [answerOption, copyOption, changeOption, pinOption, forwardOption, replyOption], widthConstant: 240.0, heightConstant: 2.0, fillColorName: nil)
        
        let moreOption = MessageManipulationTableViewCellModel(messageManipulationType: .more, isLastOption: true)
        let secondOptionSection = MessageManipulationTableViewSectionModel(title: "", cellModels: [moreOption], widthConstant: 240.0, heightConstant: 4.0, fillColorName: .messageManipulationSeparator)
        let sectionsArray = [firstOptionSection, secondOptionSection]
        sectionModels.append(sectionsArray)
        sectionsArray.forEach {
            $0.cellModels.forEach { [weak self] cellModel in
                guard let cellModel = cellModel as? MessageManipulationTableViewCellModel else { return }
                cellModel.manipulationAction = { [weak self] manipulationType in
                    self?.listener?.hideMessageManipulation(manipulationType)
                }
            }
        }
    }
    
    func lastItemIndexPath() -> IndexPath {
        let lastSectionIndex = sectionModels.count - 1
        let lastCellIndex = sectionModels[lastSectionIndex].cellModels.count - 1
        return IndexPath(row: lastCellIndex, section: lastSectionIndex)
    }
    
}
