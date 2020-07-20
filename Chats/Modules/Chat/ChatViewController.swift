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
    
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
    func showUser(with profile: Collocutor)
    func showGroupProfile()
    func hideChat()
    func showMessageManipulation(with chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: FrameValues)
}

final class ChatViewController: UIViewController {
    
    weak var listener: ChatPresentableListener?
    internal var isMessagesControllerBeingDismissed: Bool = false
    var scrollsToLastItemOnKeyboardBeginsEditing: Bool = false
    var scrollsToBottomOnKeyboardBeginsEditing: Bool = true
    var maintainPositionOnKeyboardFrameChanged: Bool = true
    internal var messageCollectionViewBottomInset: CGFloat = 0 {
        didSet {
            tableView.contentInset.bottom = messageCollectionViewBottomInset
            tableView.scrollIndicatorInsets.bottom = messageCollectionViewBottomInset
        }
    }
    
    var tableViewSectionHeaders: Set<UIView?> = []
    
    public var additionalBottomInset: CGFloat = 0 {
        didSet {
            let delta = additionalBottomInset - oldValue
            messageCollectionViewBottomInset += delta
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //MARK: - Private
    
    private var unreadMessagesCount: Int = 24
    private let collocutor = Collocutor(name: "Angie T. Trinh", collocutorImage: UIImage(named: "roflan")!, status: .online)
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    lazy var messageInputBar = InputBarAccessoryView()
    
    var messageList: [MockMessage] = [] {
        didSet {
            messageInputBar.inputTextView.text = ""
            messageListDidChange()
        }
    }
    
    private var sections: [TableViewSectionModel]? {
        didSet {
            #warning("Change logic to section reload.")
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGroupButton()
    }
    
    private func setupGroupButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Group Info", style: .plain, target: self, action: #selector(setupGroupButtonTapped))
    }
    
    @objc private func setupGroupButtonTapped() {
        listener?.showGroupProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isMessagesControllerBeingDismissed = false
        
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
            .onTypingStatus { [weak self] in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.typingIndicatorView.update(with: self?.collocutor.collocutorImage, typingPeopleCount: 10)
                    self?.tableView.tableFooterView?.isHidden = false
                }, completion: nil)
                
        }.onNewMessage { [weak self] message in
            UIView.animate(withDuration: 0.1, animations: {
                self?.messageList.append(message)
                self?.tableView.tableFooterView?.isHidden = true
            }, completion: nil)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMessagesControllerBeingDismissed = true
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isMessagesControllerBeingDismissed = false
    }
    
    private var isFirstLayout: Bool = true
    
    public override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
        }
        adjustScrollViewTopInset()
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - Views
    
    private lazy var typingIndicatorView = TypingIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30), chatType: .group)
    
    private var typingIndicatorHeightConstraint: NSLayoutConstraint?
    
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
        
        tableView.tableFooterView = typingIndicatorView
        tableView.tableFooterView?.isHidden = true
        
        return tableView
    }()
    
    private lazy var underneathView = UnderneathView
        .create { _ in }
    
    // MARK: - Private
    
    private func messageListDidChange() {
        
        let sortedViewModels = groupSort(items: messageList, isAscending: true)
        
        let sections: [TableViewSectionModel] = sortedViewModels.map {
            let oldestMessageDate = $0.first?.timestamp
            return ChatTableViewSectionModel(headerViewType: .messagesTimestamp, title: oldestMessageDate?.headerSectionDate ?? "Unknown date", cellModels: $0, headerStyle: .bubble)
        }.compactMap { $0 }
        
        self.sections = sections
    }
    
    private func groupSort(items: [ChatScreenDisplayingItems], isAscending: Bool) -> [[ChatTableViewCellModel]] {
        var groups = [[ChatScreenDisplayingItems]]()
        items.forEach { (item) in
            let groupIndex = groups.firstIndex(where: { (group) -> Bool in
                let isContains = group.contains(where: { (groupItem) -> Bool in
                    Calendar.current.isDate(groupItem.sentDate, inSameDayAs: item.sentDate)
                })
                return isContains
            })
            if let groupIndex = groupIndex {
                var group = groups[groupIndex]
                let nextIndex = group.firstIndex(where: { (groupItem) -> Bool in
                    groupItem.sentDate.compare(item.sentDate) == (isAscending ? .orderedDescending : .orderedAscending )
                })
                if let nextIndex = nextIndex {
                    group.insert(item, at: nextIndex)
                } else {
                    group.append(item)
                }
                groups[groupIndex] = group
            } else {
                let nextIndex = groups.firstIndex(where: { (group) -> Bool in
                    group[0].sentDate.compare(item.sentDate) == (isAscending ? .orderedDescending : .orderedAscending)
                })
                if let nextIndex = nextIndex {
                    groups.insert([item], at: nextIndex)
                } else {
                    groups.append([item])
                }
            }
        }
        
        return groups.compactMap {
            $0.compactMap { item in
                guard let mockMessage = item as? MockMessage else { return nil }
                var model = mockMessage.tableViewCellViewModel()
                model.messageSelection = { [weak self] chatTableViewCellModel, cellNewFrame in
                    self?.showSelectedMessageOptions(chatTableViewCellModel: chatTableViewCellModel, cellNewFrame: cellNewFrame)
                }
                return model
            }
        }
    }
    
    func showSelectedMessageOptions(chatTableViewCellModel: ChatTableViewCellModel, cellNewFrame: CGRect) {
        resignFirstResponder()
        let frameValues = FrameValues(xPositionValue: cellNewFrame.minX, yPositionValue: cellNewFrame.minY, heightValue: cellNewFrame.height, widthValue: cellNewFrame.width)
        listener?.showMessageManipulation(with: chatTableViewCellModel, cellNewFrame: frameValues)
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
        
        unreadMessagesCount == 0 ? setupBackButton(target: self, action: #selector(onBackButtonTapped)) : setupBackButton(with: unreadMessagesCount, target: self, action: #selector(onBackButtonTapped))
        
        setupNavBar(with: collocutor, target: self, action: #selector(onCollocutorViewTapped))
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
//        listener?.showGroupProfile()
    }
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSection = sections?.count else { return 0 }
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return 1
        guard let numberOfRowsInSection = sections?[section].cellModels.count else { return 0 }
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        //        guard let models = sections?[section].cellModels else { return UITableViewCell() }
        guard let cellModel = sections?[section].cellModels[row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(of: cellModel.cellType.classType)
        if let cell = cell as? TableViewCellSetup {
            cell.setup(with: cellModel)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = sections?[section],
            let classType = sectionModel.headerViewType.classType else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(of: classType)
        if let view = view as? SectionHeaderViewSetup {
            view.setup(with: sectionModel)
        }
        
        view.tintColor = UIColor.clear
        tableViewSectionHeaders.insert(view)
        
        return view
    }
}

extension ChatViewController: ChatPresentable {}
extension ChatViewController: ChatViewControllable {}
extension ChatViewController: BackButtonSettupable {}
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
                let mockImageMessage = MockMessage(assets: asset, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
                self.messageList.append(mockImageMessage)
            case .newVideo(let videoURL):
                guard let videoURL = videoURL else { return }
                alert.dismiss(animated: true, completion: nil)
                let asset = AssetMediaItem(assets: nil, imageData: nil, videoURL: videoURL)
                let mockImageMessage = MockMessage(assets: asset, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
                self.messageList.append(mockImageMessage)
            case .photo(let assets):
                let assets = AssetMediaItem(assets: assets)
                let mockAssetMessage = MockMessage(assets: assets, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
                self.messageList.append(mockAssetMessage)
            case .contact(let contact):
                guard let contact = contact else { return }
                let mockContactMessage = MockMessage(contact: contact, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
                self.messageList.append(mockContactMessage)
            case .location(let location):
                guard let location = location else { return }
                let mockLocationMessage = MockMessage(location: location, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
                self.messageList.append(mockLocationMessage)
            case .file(let file):
                guard let file = file else { return }
                let mockFileMessage = MockMessage(fileItem: file, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: true)
                self.messageList.append(mockFileMessage)
            }
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapAudioButton(_ inputBar: InputBarAccessoryView) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let mockTextMessage = MockMessage(text: text, user: SampleData.shared.currentSender, messageId: UUID().uuidString, date: Date(), isIncomingMessage: false)
        messageList.append(mockTextMessage)
    }
}

// MARK: - Scroll view delegate

extension ChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
