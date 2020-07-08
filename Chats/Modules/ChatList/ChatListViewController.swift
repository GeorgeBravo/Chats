// 
//  ChatListViewController.swift
//  Chats
//
//  Created by Касилов Георгий on 08.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

protocol ChatListPresentableListener: class {

    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ChatListViewController: UIViewController {

    weak var listener: ChatListPresentableListener?
}

extension ChatListViewController: ChatListPresentable {}

extension ChatListViewController: ChatListViewControllable {}
