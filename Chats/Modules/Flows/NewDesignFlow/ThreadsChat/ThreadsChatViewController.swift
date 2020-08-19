// 
//  ThreadsChatViewController.swift
//  Chats
//
//  Created by Mykhailo H on 8/19/20.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import BRIck

protocol ThreadsChatPresentableListener: class {

    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class ThreadsChatViewController: UIViewController {

    //MARK: - Properties
    weak var listener: ThreadsChatPresentableListener?
}

extension ThreadsChatViewController: ThreadsChatPresentable {}

extension ThreadsChatViewController: ThreadsChatViewControllable {}
