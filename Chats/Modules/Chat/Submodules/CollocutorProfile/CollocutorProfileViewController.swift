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
    func cellForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
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
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
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
        print("CollocutorProfileViewController editButtonPressed")
    }
}

extension CollocutorProfileViewController: CollocutorProfilePresentable {
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.optionsTableView.reloadData()
        }
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
        guard let cellModel = listener?.cellForRow(at: indexPath) else { return UITableViewCell() }
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
    
}
