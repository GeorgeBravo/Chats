// 
//  ChatViewController.swift
//  Chats
//
//  Created by Касилов Георгий on 24.06.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import MapKit
//import MessageKit
//
import BRIck

protocol ChatPresentableListener: class {

    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
    func showUser(with profile: Collocutor)
}

final class ChatViewController: UIViewController {

    weak var listener: ChatPresentableListener?
    
    //MARK: - Private
    
    private var unreadMessagesCount: Int = 24
    private let collocutor = Collocutor(name: "Mock", collocutorImage: UIImage(named: "roflan")!, status: .online)
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        unreadMessagesCount == 0 ? setupBackButton(target: self, action: #selector(onBackButtonTapped)) : setupBackButton(with: unreadMessagesCount, target: self, action: #selector(onBackButtonTapped))
        
        setupNavBar(with: collocutor, target: self, action: #selector(onCollocutorViewTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
            .onTypingStatus { [weak self] in
                self?.setTypingIndicatorViewHidden(false)
            }.onNewMessage { [weak self] message in
                self?.setTypingIndicatorViewHidden(true, performUpdates: {
                    self?.insertMessage(message)
                })
        }
    }
    
    // MARK: - Views
    
    private lazy var tableView = UITableView
        .create {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.white
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            $0.register(TextMessageCell.self)
            $0.register(MessageContentCell.self)
    }
}

//MARK: - Setup subviews
extension ChatViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView) {
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
        }
    }
}

//MARK: - Actions

extension ChatViewController {
    @objc
    private func onBackButtonTapped() {
        
    }
    
    @objc
    private func onCollocutorViewTapped() {
        listener?.showUser(with: collocutor)
    }
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {}
//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
extension ChatViewController: ChatPresentable {}
extension ChatViewController: ChatViewControllable {}
extension ChatViewController: BackButtonSettupable {}
extension ChatViewController: CollocutorNavBarSettupable {}

//MUSOR
extension ChatViewController {
    // MARK: - MessagesDataSource

    func didTapAttachmentsButton(_ inputBar: InputBarAccessoryView) {
        let alert = UIAlertController(style: .actionSheet)
        alert.addTelegramPicker { result in
            switch result {
            case .photo(let assets):
                break
            // action with assets
            case .contact(let contact):
                break
            // action with contact
            case .location(let location):
                break
                // action with location
            }
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        //        alert.show()
    }

    func didTapAudioButton(_ inputBar: InputBarAccessoryView) {}

//    //MARK: - MUSOR
//    override func loadFirstMessages() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let count = UserDefaults.standard.mockMessagesCount()
//            SampleData.shared.getAdvancedMessages(count: count) { messages in
//                DispatchQueue.main.async {
//                    self.messageList = messages
//                    self.messagesCollectionView.reloadData()
//                    self.messagesCollectionView.scrollToBottom()
//                }
//            }
//        }
//    }
//
//    override func loadMoreMessages() {
//        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
//            SampleData.shared.getAdvancedMessages(count: 20) { messages in
//                DispatchQueue.main.async {
//                    self.messageList.insert(contentsOf: messages, at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }
//        }
//    }

//    override func configureMessageInputBar() {
//        super.configureMessageInputBar()
//
//        messageInputBar.isTranslucent = true
//        messageInputBar.separatorLine.isHidden = true
//        messageInputBar.inputTextView.tintColor = .black
//        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
//        //        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
//        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
//        messageInputBar.inputTextView.layer.borderWidth = 1.0
//        messageInputBar.inputTextView.layer.cornerRadius = 16.0
//        messageInputBar.inputTextView.layer.masksToBounds = true
//        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        configureInputBarItems()
//    }

//    private func configureInputBarItems() {
//        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
//
//    }
//
//    private func configureInputBarPadding() {
//
//        // Entire InputBar padding
//        messageInputBar.padding.bottom = 8
//
//        // or MiddleContentView padding
//        messageInputBar.middleContentViewPadding.right = -38
//
//        // or InputTextView padding
//        messageInputBar.inputTextView.textContainerInset.bottom = 8
//
//    }
}
