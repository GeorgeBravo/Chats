// 
//  CollocutorProfileInteractor.swift
//  Chats
//
//  Created by user on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import Foundation

protocol CollocutorProfileRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol CollocutorProfilePresentable: Presentable {
    var listener: CollocutorProfilePresentableListener? { get set }
    
    func update()
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CollocutorProfileListener: class {

    func hideCollocutorProfile()
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class CollocutorProfileInteractor: PresentableInteractor<CollocutorProfilePresentable> {

    weak var router: CollocutorProfileRouting?
    weak var listener: CollocutorProfileListener?
    private var profile: Collocutor
    private var sections: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet {
            presenter.update()
        }
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.

    init(presenter: CollocutorProfilePresentable, profile: Collocutor) {
        self.profile = profile
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

extension CollocutorProfileInteractor: CollocutorProfileInteractable {}

extension CollocutorProfileInteractor: CollocutorProfilePresentableListener {
    func hideCollocutorProfile() {
        listener?.hideCollocutorProfile()
    }
    
    func combineCollocutorOptionsSections() {
        let firstSection = OptionsTableViewSectionModel(headerViewType: .options, title: "username", cellModels: [ActionTableViewCellModel(optionType: .username)])
        let secondSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .sendMessage), ActionTableViewCellModel(optionType: .addToContacts), ActionTableViewCellModel(optionType: .addToGroups)])
        let thirdSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .sharedMedia), ActionTableViewCellModel(optionType: .notification), ActionTableViewCellModel(optionType: .groupsInCommon)])
        let fourthSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .blockUser)])
        sections = [firstSection, secondSection, thirdSection, fourthSection]
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
