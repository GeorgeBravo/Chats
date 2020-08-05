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
    static let ImageBottomMarginForLargeState: CGFloat = 6
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
    func createNewChat()
    func cellForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    func deleteChats(chatIds: [Int])
    func clearHistoryForChat(chatId: Int)
    func readChats(chatIds: [Int])
    func canReadChat(chatIds: [Int])
    func setupContent()
    
    func showChat(of type: ChatType)
}

final class ChatListViewController: UITableViewController {
    
    //MARK: - Properties
    weak var listener: ChatListPresentableListener?
    var selectedCheckMarks = [Int]()
    var editListViewHeightConstraint: NSLayoutConstraint?
    private var editButtonPressed: Bool = false
    
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
    
    private lazy var editingView: ChatListEditingModeView = {
        let view = ChatListEditingModeView()
        view.delegate = self
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.7, weight: .regular)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(showEditing), for: .touchUpInside)
        return button
    }()
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
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
        tableView.keyboardDismissMode = .onDrag
        setupView()
        listener?.combineChatListSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupCreateNewButton()
        setupSearch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        createNewChatButton.removeFromSuperview()
    }
}

//MARK: - Extensions
extension ChatListViewController: ChatListPresentable {
    func readButtonEnabled(canReadChat: Bool) {
        editingView.isReadButtonEnabled = canReadChat
    }
    
    func readAllButtonDisabled(isReadEnabled: Bool) {
        editingView.isReadAllButtonEnabled = isReadEnabled
    }
    
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
        view.addSubview(editingView) {
            editListViewHeightConstraint = $0.height == 0
            $0.leading == view.leadingAnchor
            $0.width == UIScreen.main.bounds.width
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor + 40
        }
    }
    
    @objc func showEditing() {
        editButtonPressed = !editButtonPressed
         createNewChatButton.isHidden = editButtonPressed
        if editButtonPressed && !tableView.isEditing {
            tableView.setEditing(true, animated: true)
        } else if editButtonPressed && tableView.isEditing {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            tableView.setEditing(false, animated: true)
            CATransaction.commit()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
        selectedCheckMarks.removeAll()
        if tableView.isEditing {
            UIView.animate(withDuration: 0.3) {
                self.editListViewHeightConstraint?.constant = 81
                self.editingView.setupStateForButton(selectedChekmarks: 0)
                
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.editListViewHeightConstraint?.constant = 0
                self?.editingView.setupStateForButton(selectedChekmarks: 0)
            }
        }
        editButton.setTitle(tableView.isEditing ? LocalizationKeys.done.localized() : LocalizationKeys.edit.localized(), for: .normal)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    @objc func setupNewChat() {
        for subview in self.view.subviews {
            if subview.isKind(of: StatusView.self) {
                subview.removeFromSuperview()
            }
        }
        
        addContactsPicker { [unowned self] contact in
            self.listener?.showChat(of: .oneToOne)
        }
    }
    
    func addContactsPicker(selection: @escaping ContactsPickerViewController.Selection) {
        let selection : ContactsPickerViewController.Selection = selection
        let vc = ContactsPickerViewController(selection: selection)
        vc.isCreateNewChat = true
        vc.view.backgroundColor = .white
        self.present(vc, animated: true, completion: nil)
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.helveticaNeueFontOfSize(size: 20, style: .bold)]
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -40).offsetBy(dx: 0, dy: -40))!
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
        visualEffectView.layer.zPosition = -1
        self.navigationController?.view.backgroundColor = UIColor.white
        
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
        search.searchBar.delegate = self
        search.searchBar.isUserInteractionEnabled = false
        search.searchBar.placeholder = "Search for messages or users"
        search.searchBar.backgroundImage = UIImage()
        search.searchBar.setImage(UIImage(), for: .search, state: .normal)
        if let searchField = search.searchBar.value(forKey: "searchField") as? UITextField {
            
            let searchBarWidth = search.searchBar.frame.width
            let placeholderIconWidth = searchField.leftView?.frame.width
            let placeHolderWidth = searchField.attributedPlaceholder?.size().width
            let offsetIconToPlaceholder: CGFloat = 8
            let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder

            let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon - placeHolderWithIcon), vertical: 0)
            search.searchBar.setPositionAdjustment(offset, for: .search)
            searchField.textAlignment = .left
            searchField.font = UIFont(name: "HelveticaNeue", size: 16.7)
        }
        tableView.tableHeaderView = search.searchBar
    }
    
    private func setupWarningForDelete(chatId: Int?, isGroup: Bool) {
        let deleteAlert = UIAlertController(style: .alert)
        let cancelAction = UIAlertAction(title: LocalizationKeys.cancel.localized(), style: .cancel)
        cancelAction.setValue(UIColor.init(named: ColorName.blackTwo), forKey: "titleTextColor")
        let deleteAction = UIAlertAction(title: LocalizationKeys.deleteAll.localized(), style: .default) { (action) in
            isGroup ? self.listener?.clearHistoryForChat(chatId: chatId ?? 0) : self.listener?.deleteChats(chatIds: [chatId ?? 0])
        }
        deleteAction.setValue(UIColor.init(named: ColorName.pinkishRedTwo), forKey: "titleTextColor")
        deleteAlert.title = LocalizationKeys.warning.localized()
        deleteAlert.message = isGroup ? LocalizationKeys.warningForGroupChat.localized() : LocalizationKeys.warningForChat.localized()
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    private func setupAlerForDelete(indexPath: IndexPath) {
        guard let cellModel = self.listener?.cellForRow(at: indexPath) else { return }
        guard let model = cellModel as? ChatListTableViewCellModel else { return }
        let alert = UIAlertController(style: .actionSheet)
        let cancelAction = UIAlertAction(title: LocalizationKeys.cancel.localized(), style: .cancel)
        cancelAction.setValue(UIColor.init(named: ColorName.blackTwo), forKey: "titleTextColor")
        alert.addDeleteChatViewController(interlocutor: model.collocutorName, isGroup: model.isGroupChat) { [unowned self]  (action) in
            alert.dismiss(animated: true, completion: nil)
            switch action {
            case .deleteForYourselfAndInterlocutor:
                self.setupWarningForDelete(chatId: model.id, isGroup: false)
            case .deleteForYourself:
                self.listener?.deleteChats(chatIds: [model.id ?? 0])
            case .clearHistory:
                self.setupWarningForDelete(chatId: model.id, isGroup: true)
            }
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupDeleteAlertForEditing(chatIds: [Int]) {
        let moreThanOne = chatIds.count > 1
        let deleteAlert = UIAlertController(style: .actionSheet)
        let cancelAction = UIAlertAction(title: LocalizationKeys.cancel.localized(), style: .cancel)
        cancelAction.setValue(UIColor.init(named: ColorName.blackTwo), forKey: "titleTextColor")
        let deleteAction = UIAlertAction(title: moreThanOne ? String(format: LocalizationKeys.deleteMoreThanOne.localized(), chatIds.count) : LocalizationKeys.delete.localized(), style: .default) { [unowned self] (action) in
            self.listener?.deleteChats(chatIds: chatIds)
            self.showEditing()
        }
        deleteAction.setValue(UIColor.init(named: ColorName.pinkishRedTwo), forKey: "titleTextColor")
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)
        self.present(deleteAlert, animated: true, completion: nil)
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
        listener?.readChats(chatIds: selectedCheckMarks)
        showEditing()
    }
    
    func archive() {
        //
    }
    
    func delete() {
        setupDeleteAlertForEditing(chatIds: selectedCheckMarks)
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
        listener?.canReadChat(chatIds: selectedCheckMarks)
        editingView.setupStateForButton(selectedChekmarks: selectedCheckMarks.count)
    }
    
    func checkMarkSelected(chatId: Int) {
        selectedCheckMarks.append(chatId)
        listener?.canReadChat(chatIds: selectedCheckMarks)
        editingView.setupStateForButton(selectedChekmarks: selectedCheckMarks.count)
    }
    
    func ifEditButtonPressed() -> Bool {
        return editButtonPressed
    }
}

extension ChatListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //some code
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("end searching --> Close Keyboard")
        searchBar.endEditing(true)
    }
}

extension ChatListViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
//        moveAndResizeImage(for: height)
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
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let muteAction = UIContextualAction(style: .normal, title: LocalizationKeys.mute.localized()) { (action, view, completion) in
            completion(true)
        }
        muteAction.image = #imageLiteral(resourceName: "geolocation")
        muteAction.backgroundColor = UIColor.orange
        
        let deleteAction = UIContextualAction(style: .normal, title: LocalizationKeys.delete.localized()) { [unowned self] (action, view, completion) in
            self.setupAlerForDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "trahsBin")
        deleteAction.backgroundColor = UIColor.red

        let archiveAction = UIContextualAction(style: .normal, title: LocalizationKeys.archive.localized()) { (action, view, completion) in
            completion(true)
        }
        archiveAction.image = #imageLiteral(resourceName: "geolocation")
        archiveAction.backgroundColor = UIColor.lightGray
        
        return UISwipeActionsConfiguration(actions: [muteAction, deleteAction, archiveAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unreadAction = UIContextualAction(style: .normal, title: LocalizationKeys.unread.localized()) { (action, view, completion) in
            completion(true)
        }
        unreadAction.image = #imageLiteral(resourceName: "geolocation")
        unreadAction.backgroundColor = UIColor.blue

        let pinAction = UIContextualAction(style: .normal, title: LocalizationKeys.pin.localized()) { (action, view, completion) in
          completion(true)
        }
        pinAction.image = #imageLiteral(resourceName: "geolocation")
        pinAction.backgroundColor = UIColor.green
        
        return UISwipeActionsConfiguration(actions: [unreadAction, pinAction])
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatListTableViewCell else { return }
        cell.setEditing(false, animated: true)
    }
}
