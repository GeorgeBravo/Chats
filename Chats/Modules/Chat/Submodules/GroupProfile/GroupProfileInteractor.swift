// 
//  GroupProfileInteractor.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import BRIck
import Foundation

protocol GroupProfileRouting: ViewableRouting {

    // TODO: Declare methods the interactor can invoke to manage sub-tree view the router.
}

protocol GroupProfilePresentable: Presentable {
    var listener: GroupProfilePresentableListener? { get set }

    func update()
    func showAlert(with title: String, message: String)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol GroupProfileListener: class {

    func hideGroupProfile()
    // TODO: Declare methods the interactor can invoke to communicate with other BRIcks.
}

final class GroupProfileInteractor: PresentableInteractor<GroupProfilePresentable> {

    // MARK: - Variables
    weak var router: GroupProfileRouting?
    weak var listener: GroupProfileListener?

    private var sections: [TableViewSectionModel] = [TableViewSectionModel]() {
        didSet { presenter.update() }
    }
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic in constructor.
    override init(presenter: GroupProfilePresentable) {
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

extension GroupProfileInteractor: GroupProfileInteractable {}

extension GroupProfileInteractor: GroupProfilePresentableListener {
    func hideGroupProfile() {
        listener?.hideGroupProfile()
    }
    
    func combineGroupOptionsSections() {
        let firstSection = OptionsTableViewSectionModel(headerViewType: .options, title: "", cellModels: [GroupProfileTableViewCellModel(imageName: "img2", groupNameText: "Alfa Enzo Group Chat", membersCountText: "34,000 members"), DescriptionTableViewCellModel(description: "Welcome to the Alfa Enzo Community! Here's a quick overview of what this group is about:\n\nOur Site: www.alfa.io\nAbout Us: www.google.com", isShortcut: false)])
        let secondSection = OptionsTableViewSectionModel(headerViewType: .options, title: "\n\(LocalizationKeys.shortcut.localized())", cellModels: [DescriptionTableViewCellModel(description: "alfa.io/alfaenzo", isShortcut: true)])
        let thirdSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .sharedMedia, descriptionText: " "), ActionTableViewCellModel(optionType: .notification, descriptionText: "Enabled")])
        let fourthSection = OptionsTableViewSectionModel(headerViewType: .options, title: " ", cellModels: [ActionTableViewCellModel(optionType: .leaveGroup)])
        let fifthSection = OptionsTableViewSectionModel(headerViewType: .options, title: "\n", cellModels: [AddContactsTableViewCellModel(imageName: "account", addContactsText: LocalizationKeys.addContacts.localized()), UserTableViewCellModel(imageName: "Steve-Jobs", userNameText: "Steve Jobs", lastPresenceText: "online", isOnline: true, isAuthor: true), UserTableViewCellModel(imageName: "Dan-Leonard", userNameText: "Dan Leonard", lastPresenceText: "seen recently", isOnline: false, isAuthor: false)])
        sections = [firstSection, secondSection, thirdSection, fourthSection, fifthSection]
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
        if let cellModel = sections[indexPath.section].cellModels[indexPath.row] as? UserTableViewCellModel {
            presenter.showAlert(with: LocalizationKeys.action.localized(), message: cellModel.userNameText)
        }
        if let _ = sections[indexPath.section].cellModels[indexPath.row] as? AddContactsTableViewCellModel {
            presenter.showAlert(with: LocalizationKeys.action.localized(), message: LocalizationKeys.addContacts.localized())
        }
    }
}
