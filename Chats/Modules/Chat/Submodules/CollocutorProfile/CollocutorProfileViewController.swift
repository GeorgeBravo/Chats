// 
//  CollocutorProfileViewController.swift
//  Chats
//
//  Created by user on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

private struct Constants {
    static let estimatedCellHeigth: CGFloat = 100.0
}

protocol CollocutorProfilePresentableListener: class {

    func hideCollocutorProfile()
    func combineCollocutorOptionsSections()
    func cellModelForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    func didTapCell(at indexPath: IndexPath)
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class CollocutorProfileViewController: UIViewController {

    // MARK: - Variables
    weak var listener: CollocutorProfilePresentableListener?
    private lazy var optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor(named: .separatorColor)
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(ActionTableViewCell.self)
        tableView.register(OptionSectionHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupViews()
        listener?.combineCollocutorOptionsSections()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener?.hideCollocutorProfile()
    }
    
    deinit {
        print("CollocutorProfileViewController deinit")
    }
    
}

// MARK: - Setup Views
extension CollocutorProfileViewController {
    
    private func setupNavigationBarAppearance() {
        navigationController?.setNavigationBarAppearance(true)
        setupBackButton(target: self, action: #selector(onBackButtonTapped))
        setupEditButton(target: self, action: #selector(editButtonPressed))
    }
    
    private func setupViews() {
        view.addSubview(optionsTableView) {
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
        }
        view.backgroundColor = .white
    }
    
}

// MARK: - Actions
extension CollocutorProfileViewController {
    @objc func onBackButtonTapped() {
        listener?.hideCollocutorProfile()
    }
    
    @objc func editButtonPressed() {
        UIAlertController.showAlert(viewController: self,
                                    title: LocalizationKeys.action.localized(),
                                    message: LocalizationKeys.edit.localized(),
                                    actions: [UIAlertAction.okAction()])
    }
}

extension CollocutorProfileViewController: CollocutorProfilePresentable {
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.optionsTableView.reloadData()
        }
    }
    
    func showAlert(with title: String, message: String) {
        UIAlertController.showAlert(viewController: self, title: title, message: message, actions: [UIAlertAction.okAction()])
    }
}

extension CollocutorProfileViewController: CollocutorProfileViewControllable {}

extension CollocutorProfileViewController: BackButtonSettupable {}

extension CollocutorProfileViewController: EditButtonSettupable {}

extension CollocutorProfileViewController: UITableViewDelegate {}

extension CollocutorProfileViewController: UITableViewDataSource {
    
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
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(0.0, 0.0, tableView.bounds.width, 1.0))
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 0.5))
        separatorView.backgroundColor = UIColor(named: .separatorColor)
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didTapCell(at: indexPath)
    }
    
}
