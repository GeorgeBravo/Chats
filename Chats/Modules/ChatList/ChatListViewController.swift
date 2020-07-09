// 
//  ChatListViewController.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck


private struct Constants {
    static let estimatedCellHeigth: CGFloat = 150.0
}

protocol ChatListPresentableListener: class {
    func combineChatListSections()
    func cellForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    func deleteChats(chatIds: [Int])
}

final class ChatListViewController: UIViewController {

    //MARK: - Properties
    weak var listener: ChatListPresentableListener?
    var selectedCheckMarks = [Int]()
    var editListViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var chatListTableView: UITableView = {
           let tableView = UITableView()
           tableView.estimatedRowHeight = Constants.estimatedCellHeigth
           tableView.rowHeight = UITableView.automaticDimension
           tableView.tableFooterView = UIView()
           tableView.register(ChatListTableViewCell.self)
           tableView.register(ChatListSectionHeaderView.self)
           tableView.delegate = self
           tableView.dataSource = self
           return tableView
       }()
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
//        title = "Chats"
//
////        let view = ChatListLargeTitleView()
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//
//        let editButton: UIBarButtonItem = {
//            let button = UIBarButtonItem(title: "Edit", style: .done, target: nil, action: nil)
//            return button
//        }()
//        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        self.navigationItem.searchController = search
//        self.navigationItem.titleView = view
//        self.navigationItem.leftBarButtonItem = editButton
//        UINavigationBar.appearance().largeTitleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: UIColor.black]
        setupView()
        listener?.combineChatListSections()
    }
}

//MARK: - Extensions
extension ChatListViewController: ChatListPresentable {
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.chatListTableView.reloadData()
        }
    }
}
extension ChatListViewController: ChatListViewControllable {}

extension ChatListViewController {
    func setupView() {
        let largeView = ChatListLargeTitleView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 200))
        let editingView = ChatListEditingModeView()
        largeView.delegate = self
        editingView.delegate = self
        self.view.addSubview(largeView)
        
        view.addSubview(editingView) {
            editListViewHeightConstraint = $0.height == 0
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
        }
        
        view.addSubview(chatListTableView) {
            $0.top == largeView.bottomAnchor - 20
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == editingView.topAnchor
        }
    }
    
    func showEditing() {
        chatListTableView.setEditing(!chatListTableView.isEditing, animated: true)
        selectedCheckMarks.removeAll()
        if chatListTableView.isEditing {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.editListViewHeightConstraint?.constant = 100
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.editListViewHeightConstraint?.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func removeEditingView() {
        for subview in view.subviews {
            if subview.isKind(of: ChatListEditingModeView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}

extension ChatListViewController: ChatListLargeTitleViewProtocol {
    func editAction() {
        showEditing()
    }
}

extension ChatListViewController: ChatListEditingModeViewProtocol {
    func readAll() {
        //
    }
    
    func archive() {
        //
    }
    
    func delete() {
        listener?.deleteChats(chatIds: selectedCheckMarks)
        showEditing()
    }
}

extension ChatListViewController: ChatListTableViewCellDelegate {
    func checkMarkUnselected(chatId: Int) {
        selectedCheckMarks.removeAll { (id) -> Bool in
            if id == chatId {
                return true
            }
            return false
        }
    }
    
    func checkMarkSelected(chatId: Int) {
        selectedCheckMarks.append(chatId)
    }
}

extension ChatListViewController: UITableViewDelegate {}

extension ChatListViewController: UITableViewDataSource {
    
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
        if let chatCell = cell as? ChatListTableViewCell {
            chatCell.delegate = self
        }
        if let cell = cell as? TableViewCellSetup, var model = cellModel as? ChatListTableViewCellModel {
            if selectedCheckMarks.contains(where: { $0 == model.id }) {
                model.isSelected = true
            } else {
                model.isSelected = false
            }
            model.isEditing = tableView.isEditing
            cell.setup(with: model)
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        print(indexPath)
        return .none
    }
}
