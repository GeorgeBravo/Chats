// 
//  ChatViewController.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import MapKit
import BRIck

struct FrameValues {
    var xPositionValue: CGFloat
    var yPositionValue: CGFloat
    var heightValue: CGFloat
    var widthValue: CGFloat
}

protocol ChatPresentableListener: class {
    
    func connectMockSocket(with chatType: ChatType)
    func disconnectMockSocket()
    
    func cellModelForRow(at: IndexPath) -> TableViewCellModel
    func numberOfRows(in section: Int) -> Int
    func numberOfSection() -> Int
    func sectionModel(for number: Int) -> TableViewSectionModel
    
    func showUser(with profile: Collocutor)
    func showGroupProfile()
    func hideChat()
    
    var messageList: [MockMessage] { get set }
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ChatViewController: UIViewController {
    
    weak var listener: ChatPresentableListener?
    
    private var isFirstLayout: Bool = true
    
    public var chatTableViewBottomInset: CGFloat = 0 {
        didSet {
            tableView.contentInset.bottom = chatTableViewBottomInset
            tableView.scrollIndicatorInsets.bottom = chatTableViewBottomInset
        }
    }
    
    public var additionalBottomInset: CGFloat = 0 {
        didSet {
            let delta = additionalBottomInset - oldValue
            chatTableViewBottomInset += delta
        }
    }
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Private
    
    private let chatType: ChatType
    
    private var unreadMessagesCount: Int = 24
    
    private let collocutor = Collocutor(name: "Angie T. Trinh", collocutorImage: UIImage(named: "roflan")!, status: .online)
    
    private let groupInfoModel = ChatListTableViewCellModel(title: "", collocutorName: "Alfa Enzo Group Chat", message: "Just a quick reminder! We need to book flights back from the trip beca..." , timeSent: "1.15 P.M", imageLink: "img2", messageCount: 2, id: 0, isGroupChat: true, lastSender: "You", membersCount: 322000, membersOnline: 1210)
    
    
    //MARK: - Lifecycle
    
    init(with chatType: ChatType) {
        self.chatType = chatType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.connectMockSocket(with: chatType)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.disconnectMockSocket()
    }
    
    override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
//            chatTableViewBottomInset = requiredInitialScrollViewBottomInset()
        }
        
//        adjustScrollViewTopInset()
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
//        chatTableViewBottomInset = requiredInitialScrollViewBottomInset()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - Views
    
    public lazy var messageInputBar = InputBarAccessoryView()
    
    private lazy var typingIndicatorView = TypingIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30), chatType: self.chatType)
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.register(TextMessageCell.self)
        tableView.register(MessageContentCell.self)
        tableView.register(LocationMessageCell.self)
        tableView.register(ChatSectionHeaderView.self)
        tableView.register(MediaMessageCell.self)
        tableView.register(FileMessageCell.self)
        tableView.register(ContactMessageCell.self)
        tableView.register(UserChatEntryTableViewCell.self)
        
        tableView.tableFooterView = typingIndicatorView
        tableView.tableFooterView?.isHidden = true
        
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var underneathView = UnderneathView
        .create { _ in }
    
    private lazy var chatScrollDownView = ChatScrollDownView
        .create {
            $0.isHidden = true
            $0.onArrowDidTap = { [unowned self] in
                self.tableView.scrollToLastItem()
            }
    }
    
    // MARK: - Private
    
    private func showChatScrollDownViewIfNeeded() {
        guard let lastVisibleCell = tableView.visibleCells.last,
            let lastVisibleCellIndexPath = tableView.indexPath(for: lastVisibleCell),
            let numberOfRowsInSection = listener?.numberOfRows(in: lastVisibleCellIndexPath.section) else { return }
        
        if numberOfRowsInSection - 1 >= lastVisibleCellIndexPath.row + 1 {
            chatScrollDownView.isHidden = false
        } else {
            chatScrollDownView.isHidden = true
        }
    }
}

//MARK: - Setup subviews
extension ChatViewController {
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = .white
        
        view.addSubview(underneathView) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            let height = UIApplication.shared.statusBarFrame.height +
                self.navigationController!.navigationBar.frame.height
            $0.height == 100 - height
        }
        
        view.addSubview(tableView) {
            $0.top == underneathView.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
        
        view.addSubview(chatScrollDownView) {
            $0.trailing == view.trailingAnchor - 10
            $0.bottom == view.bottomAnchor - 100
        }
        
        unreadMessagesCount == 0 ? setupBackButton(target: self, action: #selector(onBackButtonTapped)) : setupBackButton(with: unreadMessagesCount, target: self, action: #selector(onBackButtonTapped))
        
        switch chatType {
        case .oneToOne:
            setupNavBar(with: collocutor, target: self, action: #selector(onCollocutorViewTapped))
        case .group:
            setupNavBar(with: groupInfoModel, target: self, action: #selector(onGroupInfoViewTapped))
        }
        
        configureMessageInputBar()
        
        typingIndicatorView.isHidden = true
    }
}

// MARK: - Actions

extension ChatViewController {
    @objc private func onBackButtonTapped() {
        listener?.hideChat()
    }
    
    @objc
    private func onCollocutorViewTapped() {
        listener?.showUser(with: collocutor)
    }
    
    @objc
    private func onGroupInfoViewTapped() {
        listener?.showGroupProfile()
    }
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        
        showChatScrollDownViewIfNeeded()
        showHeader()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        showOrHideHeader()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        showOrHideHeader()
    }
    
    private func showOrHideHeader(hideDuration: Double = 1.0) {
        guard let firstVisibleCell = tableView.visibleCells.first else { return }
        guard let firstVisibleCellIndexPath = tableView.indexPath(for: firstVisibleCell) else { return }
        
        let needToShowHeader: Bool = firstVisibleCellIndexPath.row == 0 ? true : false
        
        switch needToShowHeader {
        case true:
            showHeader()
        case false:
            hideHeader(with: hideDuration)
        }
    }
    
    private func showHeader() {
        guard let firstVisibleCell = tableView.visibleCells.first else { return }
        guard let firstVisibleCellIndexPath = tableView.indexPath(for: firstVisibleCell) else { return }
        
        guard let header = tableView.headerView(forSection: firstVisibleCellIndexPath.section) else { return }
        let headerAlpha: CGFloat = 1.0
        
        header.isHidden = false
        UIView.animate(withDuration: 0.1) {
            header.alpha = headerAlpha
        }
    }
    
    private func hideHeader(with duration: Double =  1.0) {
        guard let firstVisibleCell = tableView.visibleCells.first else { return }
        guard let firstVisibleCellIndexPath = tableView.indexPath(for: firstVisibleCell) else { return }
        
        guard let header = tableView.headerView(forSection: firstVisibleCellIndexPath.section) else { return }
        let headerAlpha: CGFloat = 0.0
        
        UIView.animate(withDuration: duration) {
            header.alpha = headerAlpha
        }
    }
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        showChatScrollDownViewIfNeeded()
//                let section = indexPath.section
//
//                if let lastCellRowIndex = tableView.indexPathsForVisibleRows?.last?.row,
//                    let numberOfRowsInSection = listener?.numberOfRows(in: section) {
//                    if numberOfRowsInSection - 1 >= lastCellRowIndex {
//                        chatScrollDownView.isHidden = false
//                    } else {
//                        chatScrollDownView.isHidden = true
//                    }
//                }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = listener?.sectionModel(for: section),
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        
        view.tintColor = UIColor.clear
        
        return view
    }
}

// MARK: - ChatPresentable
extension ChatViewController: ChatPresentable {
    
    #warning("Change logic to section reload.")
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData() { [weak self] in
                self?.showOrHideHeader(hideDuration: 0.0)
            }
        }
    }
    
    func execute(messageManipulationType: MessageManipulationType) {
        UIAlertController.showAlert(viewController: self, title: LocalizationKeys.action.localized(), message: messageManipulationType.stringDescription, actions: [UIAlertAction.okAction()])
    }
    
    func onTypingStatus() {
        UIView.animate(withDuration: 0.1, animations: {
            self.typingIndicatorView.update(with: self.collocutor.collocutorImage, typingPeopleCount: 10)
            self.tableView.tableFooterView?.isHidden = false
        }, completion: nil)
    }
    
    func onNewMessage(_ message: MockMessage) {
        UIView.animate(withDuration: 0.1, animations: {
            self.tableView.tableFooterView?.isHidden = true
            
            if case .addUserToChat = message.messageKind { return }
            
            if !message.isIncomingMessage {
                self.tableView.scrollToLastItem()
            } else {
                if self.chatScrollDownView.isHidden {
                    self.tableView.scrollToLastItem()
                } else {
                    self.chatScrollDownView.unreadMessageCount += 1
                }
            }
        }, completion: nil)
    }
}

// MARK: - ChatViewControllable
extension ChatViewController: ChatViewControllable {}

// MARK: - BackButtonSettupable
extension ChatViewController: BackButtonSettupable {}

// MARK: - CollocutorNavBarSettupable
extension ChatViewController: CollocutorNavBarSettupable {}

extension ChatViewController {
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        
        messageInputBar.isTranslucent = true
        
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .black
        
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func didTapAttachmentsButton(_ inputBar: InputBarAccessoryView) {
        inputBar.inputTextView.resignFirstResponder()
        
        let alert = UIAlertController(style: .actionSheet)
        alert.addTelegramPicker { [unowned self] result in
            switch result {
            case .newPhoto(let photo):
                guard let photo = photo, let photoData = photo.pngData() else {
                    self.resignFirstResponder()
                    return
                }
                alert.dismiss(animated: true, completion: nil)
                let asset = AssetMediaItem(assets: nil, imageData: photoData, videoURL: nil)
                let mockImageMessage = MockMessage(assets: asset, date: Date(), isIncomingMessage: false, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockImageMessage)
            case .newVideo(let videoURL):
                guard let videoURL = videoURL else { return }
                alert.dismiss(animated: true, completion: nil)
                let asset = AssetMediaItem(assets: nil, imageData: nil, videoURL: videoURL)
                let mockImageMessage = MockMessage(assets: asset, date: Date(), isIncomingMessage: false, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockImageMessage)
            case .photo(let assets):
                let assets = AssetMediaItem(assets: assets)
                let mockAssetMessage = MockMessage(assets: assets, date: Date(), isIncomingMessage: false, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockAssetMessage)
            case .contact(let contact):
                guard let contact = contact else { return }
                let mockContactMessage = MockMessage(contact: contact, date: Date(), isIncomingMessage: false, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockContactMessage)
            case .location(let location):
                guard let location = location else { return }
                let mockLocationMessage = MockMessage(location: location, date: Date(), isIncomingMessage: false, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockLocationMessage)
            case .file(let file):
                guard let file = file else { return }
                let mockFileMessage = MockMessage(fileItem: file, date: Date(), isIncomingMessage: true, chatType: self.chatType, messageId: UUID().uuidString)
                self.listener?.messageList.append(mockFileMessage)
            }
        }
        
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapAudioButton(_ inputBar: InputBarAccessoryView) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        var mockTextMessage = MockMessage(text: text, date: Date(), isIncomingMessage: false, chatType: chatType, messageId: UUID().uuidString)
        self.messageInputBar.inputTextView.text = ""
        listener?.messageList.append(mockTextMessage)
        onNewMessage(mockTextMessage)
    }
}
