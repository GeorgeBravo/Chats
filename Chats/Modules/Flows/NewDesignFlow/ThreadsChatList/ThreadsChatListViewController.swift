// 
//  ThreadsChatListViewController.swift
//  Chats
//
//  Created by Mykhailo H on 8/18/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

protocol ThreadsChatListPresentableListener: class {
    
    func combineChatListSections()
    func cellForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    
    func showCameraScreen()
    func hideCameraScreen()
    func showChat()
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ThreadsChatListViewController: UIViewController {
    
    // MARK: - Properties
    var navigationBarViewHeightConstraint: NSLayoutConstraint?
    private var lastContentOffset: CGFloat = 0
    
    private var selectedIndexPath: IndexPath?
    
    // MARK: - UI Variables
    private var navigationBarView: NewCustomChatListNavigationView = {
        let view = NewCustomChatListNavigationView()
        return view
    }()
    
    weak var listener: ThreadsChatListPresentableListener?
    private var cellSpacingHeight: CGFloat = 50
    private lazy var search = UISearchController(searchResultsController: nil)
    private lazy var searchView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 46))
    private lazy var chatTableView = UITableView
        .create { 
            $0.estimatedRowHeight = 200
            $0.rowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
            $0.tableHeaderView = searchView
            $0.register(ThreadsChatListTableViewCell.self)
            $0.register(ChatListSectionHeaderView.self)
            $0.separatorColor = UIColor.clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
        setupSearch()
        listener?.combineChatListSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension ThreadsChatListViewController {
    private func setupView() {
        view.addSubview(navigationBarView) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor
            navigationBarViewHeightConstraint = $0.height == 60
        }
        
        view.addSubview(chatTableView) {
            $0.top == navigationBarView.bottomAnchor
            $0.bottom == view.bottomAnchor
            $0.width == view.frame.width
        }
        searchView.addSubview(search.searchBar) {
            $0.top == searchView.topAnchor + 10
            $0.bottom == searchView.bottomAnchor
            $0.leading == searchView.leadingAnchor + 12
            $0.trailing == searchView.trailingAnchor - 12
        }
        navigationBarView.delegate = self
    }
    
    @objc func incrementProgress() {
        navigationBarView.cameraButton.progress += 0.01
    }
    
    private func setupSearch() {
        search.searchBar.isUserInteractionEnabled = false
        search.searchBar.placeholder = "Search"
        search.searchBar.textField?.layer.cornerRadius = 18
        search.searchBar.textField?.clipsToBounds = true
        search.searchBar.backgroundImage = UIImage()
        search.searchBar.setImage(UIImage(), for: .search, state: .normal)
        if let searchField = search.searchBar.value(forKey: "searchField") as? UITextField {
            let offset = UIOffset(horizontal: 25.0, vertical: 0)
            search.searchBar.setPositionAdjustment(offset, for: .search)
            searchField.textAlignment = .left
            searchField.font = UIFont(name: "HelveticaNeue", size: 16.7)
        }
    }
}

extension ThreadsChatListViewController: ThreadsChatListPresentable {
    func setupNoChatsView() {
        let statusView = StatusView(logo: UIImage(named: "noChats"), title: "Where’s the party?", placeholder: nil, buttonTitle: nil, textAlignment: nil, placeholderAlignment: nil, style: .subtitled)
        statusView.frame = CGRect(x: 0, y: 0, width: view.width, height: UIScreen.main.bounds.height)
        chatTableView.isScrollEnabled = false
        view.addSubview(statusView)
    }
    
    func update() {
        DispatchQueue.main.async { [unowned self] in
            self.chatTableView.reloadData()
        }
    }
}

// MARK: - Selectors
extension ThreadsChatListViewController {
    @objc func goToCameraScreen() {
        listener?.showCameraScreen()
    }
}


// MARK: - ThreadsChatListViewControllable
extension ThreadsChatListViewController: ThreadsChatListViewControllable {}

extension ThreadsChatListViewController: UITableViewDataSource , UITableViewDelegate {
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
        if let cell = cell as? TableViewCellSetup, let model = cellModel as? ThreadsChatListTableViewCellModel {
            cell.setup(with: model)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.tintColor = .clear
            return view
        }
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        view.tintColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changedOffset = scrollView.contentOffset.y - self.lastContentOffset
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            if scrollView.contentOffset.y > 0 {
                navigationBarViewHeightConstraint?.constant -= changedOffset / 2
                if navigationBarViewHeightConstraint?.constant < 52 {
                    navigationBarView.setHidden(hidded: true)
                }
            }
        }
        else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            if scrollView.contentOffset.y > 0 {
                navigationBarViewHeightConstraint?.constant += -changedOffset / 2
                if navigationBarViewHeightConstraint?.constant > 52 {
                    navigationBarView.setHidden(hidded: false)
                }
            }
        }
        
        if scrollView.contentOffset.y <= 0 && scrollView.contentOffset.y >= -200 {
            navigationBarView.cameraButton.progress = -scrollView.contentOffset.y / 100
        }
        
        if scrollView.contentOffset.y <= 0 && scrollView.contentOffset.y <= -100 && self.lastContentOffset < scrollView.contentOffset.y {
            if navigationBarView.cameraButton.fullProgress {
                listener?.showCameraScreen()
            }
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        if scrollView.contentOffset.y == 0 {
            navigationBarViewHeightConstraint?.constant = 60
            navigationBarView.cameraButton.progress = 0
            navigationBarView.setHidden(hidded: false)
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        listener?.showChat()
    }
}

// MARK: - NewCustomChatListNavigationViewDelegate
extension ThreadsChatListViewController: NewCustomChatListNavigationViewDelegate {
    func pencilButtonTapped() {
        
    }
    
    func avatarButtonTapped() {
        
    }
    
    func cameraButtonTapped() {
        goToCameraScreen()
    }
}

extension ThreadsChatListViewController: SlidingCellDelegate {
        func hasPerformedSwipe(touch: CGPoint) {
            if let indexPath = chatTableView.indexPathForRow(at: touch) {
                // Access the image or the cell at this index path
                print("got a swipe row:\(indexPath.row)")
            }
        }
        
        func hasPerformedTap(touch: CGPoint) {
            print("yo")
            if let indexPath = chatTableView.indexPathForRow(at: touch) {
                // Access the image or the cell at this index path
                print("got a tap row:\(indexPath.row)")
            }
        }
    }

        
extension ThreadsChatListViewController: ChatAnimatorDelegate {
    
    private func chatCell() -> ThreadsChatListTableViewCell? {
        guard let indexPath = selectedIndexPath else { return nil }
        return chatTableView.cellForRow(at: indexPath) as? ThreadsChatListTableViewCell
    }
        
    func frame(for animator: ChatAnimator) -> CGRect? {
        guard let cell = chatCell() else { return nil }
        
        return chatTableView.convert(cell.frame, to: view)
    }
    
    func snapshot(for animator: ChatAnimator) -> UIView? {
        chatCell()?.snapshotView(afterScreenUpdates: false)
    }
        
    func imageSnapshot(for animator: ChatAnimator) -> UIView? {
        chatCell()?.avatarView.snapshotView(afterScreenUpdates: false)
    }
    
    func imageFrame(for animator: ChatAnimator) -> CGRect? {
        guard let chatCell = chatCell() else { return nil }
        return chatCell.avatarView.superview?.convert(chatCell.avatarView.frame, to: chatCell)
    }
    
    func nameLabel(for animator: ChatAnimator) -> UIView? {
        chatCell()?.userName.snapshotView(afterScreenUpdates: false)
    }
    
    func nameLabelFrame(for animator: ChatAnimator) -> CGRect? {
        guard let chatCell = chatCell() else { return nil }
        return chatCell.userName.superview?.convert(chatCell.userName.frame, to: chatCell)
    }
    
    func animationDidStart(for imageAnimator: ChatAnimator) {
        chatCell()?.isHidden = true
    }
    
    func animationDidEnd(for imageAnimator: ChatAnimator) {
        chatCell()?.isHidden = false
    }
}
