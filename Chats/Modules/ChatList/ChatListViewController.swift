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
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

protocol ChatListPresentableListener: class {
    func combineChatListSections()
    func cellForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    func deleteChats(chatIds: [Int])
    func setupContent()
    
    func showChat(of type: ChatType)
}

final class ChatListViewController: UITableViewController {
    
    //MARK: - Properties
    weak var listener: ChatListPresentableListener?
    var selectedCheckMarks = [Int]()
    var editListViewHeightConstraint: NSLayoutConstraint?
    
    private lazy var chatListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(ChatListTableViewCell.self)
        tableView.register(ChatListSectionHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var createNewChatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "newChatIcon"), for: .normal)
        button.addTarget(self, action: #selector(setupNewChat), for: .touchUpInside)
        return button
    }()
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupNavigationBar()
        tableView = UITableView(frame: .zero, style: .grouped)
        self.view.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.clear
        tableView.estimatedRowHeight = Constants.estimatedCellHeigth
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(ChatListTableViewCell.self)
        tableView.register(ChatListSectionHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        setupView()
        listener?.combineChatListSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupCreateNewButton()
        setupSearch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        createNewChatButton.removeFromSuperview()
    }
}

//MARK: - Extensions
extension ChatListViewController: ChatListPresentable {
    func setupNoChatsView() {
        let statusView = StatusView(logo: UIImage(named: "noChats"), title: "Where’s the party?", placeholder: nil, buttonTitle: nil, textAlignment: nil, placeholderAlignment: nil, style: .subtitled)
        statusView.frame = CGRect(x: 0, y: 0, width: view.width, height: UIScreen.main.bounds.height)
        tableView.isScrollEnabled = false
        view.addSubview(statusView)
    }
    
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}
extension ChatListViewController: ChatListViewControllable {}

extension ChatListViewController {
    func setupView() {
        //        let largeView = ChatListLargeTitleView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 200))
        let editingView = ChatListEditingModeView()
        //        largeView.delegate = self
        editingView.delegate = self
        //        self.view.addSubview(largeView)
        
        view.addSubview(editingView) {
            editListViewHeightConstraint = $0.height == 0
            $0.leading == view.leadingAnchor
            $0.width == UIScreen.main.bounds.width
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor + 40
        }
        
        //        view.addSubview(chatListTableView) {
        //            $0.top == view.safeAreaLayoutGuide.topAnchor
        //            $0.leading == view.leadingAnchor
        //            $0.trailing == view.trailingAnchor
        //            $0.bottom == editingView.topAnchor
        //        }
    }
    
    @objc func showEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        selectedCheckMarks.removeAll()
        if tableView.isEditing {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.editListViewHeightConstraint?.constant = 81
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.editListViewHeightConstraint?.constant = 0
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func setupNewChat() {
        for subview in self.view.subviews {
            if subview.isKind(of: StatusView.self) {
                subview.removeFromSuperview()
            }
        }
        tableView.isScrollEnabled = true
        listener?.setupContent()
        listener?.combineChatListSections()
    }
    
    func removeEditingView() {
        for subview in view.subviews {
            if subview.isKind(of: ChatListEditingModeView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        title = "Chats"
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.view.backgroundColor = UIColor.white
        
        let editButton: UIButton = {
            let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .left
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.7, weight: .regular)
            button.addTarget(self, action: #selector(showEditing), for: .touchUpInside)
            return button
        }()
        
        let editButButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.leftBarButtonItem = editButButtonItem
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        
    }
    
    private func setupCreateNewButton() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(createNewChatButton)
        createNewChatButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNewChatButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Constants.ImageRightMargin),
            createNewChatButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Constants.ImageBottomMarginForLargeState),
            createNewChatButton.heightAnchor.constraint(equalToConstant: Constants.ImageSizeForLargeState),
            createNewChatButton.widthAnchor.constraint(equalTo: createNewChatButton.heightAnchor)
        ])
        
    }
    
    private func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Search for messages or users"
        search.searchBar.backgroundImage = UIImage()
        let offset = UIOffset(horizontal: 50, vertical: 0)
        search.searchBar.setPositionAdjustment(offset, for: .search)
        if let searchField = search.searchBar.value(forKey: "searchField") as? UITextField {
            
            searchField.textAlignment = .center
            searchField.font = UIFont(name: "HelveticaNeue", size: 16.7)
        }
        
        tableView.tableHeaderView = search.searchBar
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Constants.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Constants.NavBarHeightLargeState - Constants.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Constants.ImageSizeForSmallState / Constants.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Constants.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Constants.ImageBottomMarginForLargeState - Constants.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Constants.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        createNewChatButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
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

extension ChatListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //some code
    }
}

extension ChatListViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSection = listener?.numberOfSection() else { return 0 }
        return numberOfSection
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = listener?.numberOfRows(in: section) else { return 0 }
        return numberOfRowsInSection
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        view.tintColor = UIColor.clear 
        return view
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                listener?.showChat(of: .group)
            case 1:
                listener?.showChat(of: .oneToOne)
            default:
                break
            }
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//                self.navigationItem.largeTitleDisplayMode = .never
            }
        }
    }
}
