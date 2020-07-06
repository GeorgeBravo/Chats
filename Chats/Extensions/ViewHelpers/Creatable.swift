//
//  Creatable.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

protocol Creatable: class {}

extension Creatable where Self: NSObject {
    @discardableResult
    static func create( configure: (Self) -> Void = { _ in }) -> Self {
        let view = Self()
        configure(view)

        return view
    }
}
