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

    func hideMessageManipulation()
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class MessageManipulationInteractor: PresentableInteractor<MessageManipulationPresentable> {

    weak var router: MessageManipulationRouting?
    weak var listener: MessageManipulationListener?
    private var cellNewFrame: FrameValues
    private var cellModels: [TableViewCellModel] = [TableViewCellModel]() {
        didSet {
            presenter.update()
        }
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    init(presenter: MessageManipulationPresentable, chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: FrameValues) {
        self.cellNewFrame = cellNewFrame
        super.init(presenter: presenter)
        presenter.listener = self
        cellModels.append(chatTableViewCellModel)
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
        listener?.hideMessageManipulation()
    }
    
    func numberOfRows() -> Int {
        return cellModels.count
    }
    
    func cellModelForRow(at indexPath: IndexPath) -> TableViewCellModel {
        return cellModels[indexPath.row]
    }
    
    func cellOffsetFrame() -> FrameValues {
        return cellNewFrame
    }
}
