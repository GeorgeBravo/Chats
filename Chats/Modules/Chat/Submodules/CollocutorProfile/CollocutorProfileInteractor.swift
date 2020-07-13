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
    func showAlert(with title: String, message: String)
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
    
    // MARK: - TableView logic
    func combineCollocutorOptionsSections() {
        var collocutorInfoCellModel = CollocutorInfoCellModel(collocutor: profile, lastSeenDescriptionText: LocalizationKeys.lastSeenRecently.localized())
        collocutorInfoCellModel.manipulationCallback = { [weak self] manipulation in
            self?.presenter.showAlert(with: LocalizationKeys.action.localized(), message: manipulation.stringDescription)
        }
        let zeroSection = OptionsTableViewSectionModel(headerViewType: .options, title: "", cellModels: [collocutorInfoCellModel])
        let firstSection = OptionsTableViewSectionModel(headerViewType: .options, title: "username", cellModels: [ActionTableViewCellModel(optionType: .username)])
        let secondSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .sendMessage), ActionTableViewCellModel(optionType: .addToContacts), ActionTableViewCellModel(optionType: .addToGroups)])
        let thirdSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .sharedMedia, descriptionText: " "), ActionTableViewCellModel(optionType: .notification, descriptionText: "Enabled"), ActionTableViewCellModel(optionType: .groupsInCommon, descriptionText: "3")])
        let fourthSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .blockUser)])
        sections = [zeroSection, firstSection, secondSection, thirdSection, fourthSection]//, firstSection, secondSection, thirdSection, fourthSection]
    }
    
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
    
    func didTapCell(at indexPath: IndexPath) {
        if let cellModel = sections[indexPath.section].cellModels[indexPath.row] as? ActionTableViewCellModel, let message = cellModel.title {
            presenter.showAlert(with: LocalizationKeys.action.localized(), message: message)
        }
    }
    
    func collocutorName() -> String {
        return profile.name
    }
    
}
