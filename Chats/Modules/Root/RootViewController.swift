//
//  RootViewController.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import BRIck
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform business logic, such as signIn().
    // This protocol is implemented by the corresponding interactor class.
}

final class RootViewController: UIViewController {
    weak var listener: RootPresentableListener?
}

extension RootViewController: RootPresentable {}

extension RootViewController: RootViewControllable {}
