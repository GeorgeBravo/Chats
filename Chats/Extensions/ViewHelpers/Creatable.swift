//
//  Creatable.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation
import UIKit

protocol Creatable: class {}

extension Creatable where Self: UIView {
    @discardableResult
    static func create( configure: (Self) -> Void = { _ in }) -> Self {
        let view = Self()
        configure(view)

        return view
    }
}
