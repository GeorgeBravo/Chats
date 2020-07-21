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
    func showMessageManipulation(with chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: FrameValues)
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
    
    // MARK: - Data Source
    private var messageList: [MockMessage] = [] {
        didSet {
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
    
    lazy var messageInputBar = InputBarAccessoryView()
    
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
        
        MockSocket.shared.connect(with: chatType)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MockSocket.shared.disconnect()
    }
    
    public override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            chatTableViewBottomInset = requiredInitialScrollViewBottomInset()
        }
        
        adjustScrollViewTopInset()
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        chatTableViewBottomInset = requiredInitialScrollViewBottomInset()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - Views
    
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
                
                if var model = mockMessage.tableViewCellViewModel as? ChatContentTableViewCellModel {
                    model.messageSelection = { [weak self] chatTableViewCellModel, cellNewFrame in
                        self?.showSelectedMessageOptions(chatTableViewCellModel: chatTableViewCellModel, cellNewFrame: cellNewFrame)
                    }
                    return model
                } else {
                    return mockMessage.tableViewCellViewModel
                }
            }

        }
    }
    
    func showSelectedMessageOptions(chatTableViewCellModel: ChatContentTableViewCellModel, cellNewFrame: CGRect) {
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
                let mockImageMessage = MockMessage(assets: asset, date: Date(), isIncomingMessage: false, chatType: self.chatType)
                self.messageList.append(mockImageMessage)
            case .newVideo(let videoURL):
                guard let videoURL = videoURL else { return }
                alert.dismiss(animated: true, completion: nil)
                let asset = AssetMediaItem(assets: nil, imageData: nil, videoURL: videoURL)
                let mockImageMessage = MockMessage(assets: asset, date: Date(), isIncomingMessage: false, chatType: self.chatType)
                self.messageList.append(mockImageMessage)
            case .photo(let assets):
                let assets = AssetMediaItem(assets: assets)
                let mockAssetMessage = MockMessage(assets: assets, date: Date(), isIncomingMessage: false, chatType: self.chatType)
                self.messageList.append(mockAssetMessage)
            case .contact(let contact):
                guard let contact = contact else { return }
                let mockContactMessage = MockMessage(contact: contact, date: Date(), isIncomingMessage: false, chatType: self.chatType)
                self.messageList.append(mockContactMessage)
            case .location(let location):
                guard let location = location else { return }
                let mockLocationMessage = MockMessage(location: location, date: Date(), isIncomingMessage: false, chatType: self.chatType)
                self.messageList.append(mockLocationMessage)
            case .file(let file):
                guard let file = file else { return }
                let mockFileMessage = MockMessage(fileItem: file, date: Date(), isIncomingMessage: true, chatType: self.chatType)
                self.messageList.append(mockFileMessage)
            }
            self.messageInputBar.inputTextView.text = ""
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapAudioButton(_ inputBar: InputBarAccessoryView) {}
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let mockTextMessage = MockMessage(text: text, date: Date(), isIncomingMessage: false, chatType: chatType)
        messageList.append(mockTextMessage)
    }
}
