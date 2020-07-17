// 
//  GroupProfileViewController.swift
//  Chats
//
//  Created by user on 13.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

private struct Constants {
    static let estimatedCellHeigth: CGFloat = 100.0
}

protocol GroupProfilePresentableListener: class {

    func hideGroupProfile()
    func combineGroupOptionsSections()
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func cellModelForRow(at: IndexPath) -> TableViewCellModel
    func sectionModel(for number: Int) -> TableViewSectionModel
    func didTapCell(at indexPath: IndexPath)
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class GroupProfileViewController: UIViewController {

    // MARK: - Variables
    weak var listener: GroupProfilePresentableListener?
    
    private lazy var optionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView()
        tableView.register(GroupProfileTableViewCell.self)
        tableView.register(DescriptionTableViewCell.self)
        tableView.register(OptionSectionHeaderView.self)
        tableView.register(ActionTableViewCell.self)
        tableView.register(CollocutorProfileTableViewCell.self)
        tableView.register(AddContactsTableViewCell.self)
        tableView.register(UserTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        listener?.combineGroupOptionsSections()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener?.hideGroupProfile()
    }
}

extension GroupProfileViewController {
    private func setupViews() {
        navigationController?.setNavigationBarAppearance(true, bigFont: false)
        navigationItem.title = LocalizationKeys.groupInfo.localized()
        setupBackButton(target: self, action: #selector(backButtonTapped))
        setupEditButton(target: self, action: #selector(editButtonPressed))
        
        view.addSubview(optionsTableView) {
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
        }
    }
}

// MARK: - Selectors
extension GroupProfileViewController {
    @objc func backButtonTapped() {
        listener?.hideGroupProfile()
    }
    
    @objc func editButtonPressed() {
        UIAlertController.showAlert(viewController: self,
                                    title: LocalizationKeys.action.localized(),
                                    message: LocalizationKeys.edit.localized(),
                                    actions: [UIAlertAction.okAction()])
    }
}

extension GroupProfileViewController: GroupProfilePresentable {
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.optionsTableView.reloadData()
        }
    }
    
    func showAlert(with title: String, message: String) {
        UIAlertController.showAlert(viewController: self,
                                    title: title,
                                    message: message,
                                    actions: [UIAlertAction.okAction()])
    }
}

extension GroupProfileViewController: BackButtonSettupable {}

extension GroupProfileViewController: EditButtonSettupable {}

extension GroupProfileViewController: GroupProfileViewControllable {}

// MARK: - Table View Delegate
extension GroupProfileViewController: UITableViewDelegate {}

// MARK: - Table View Data Source
extension GroupProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSection = listener?.numberOfSection() else { return 0 }
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = listener?.numberOfRows(in: section) else { return 0 }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = listener?.cellModelForRow(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(of: cellModel.cellType.classType)
        if let cell = cell as? TableViewCellSetup {
            cell.setup(with: cellModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        view.tintColor = UIColor(named: .whiteColor)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didTapCell(at: indexPath)
    }
}
