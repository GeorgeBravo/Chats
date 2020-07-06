//
//  Create.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2019 RestySpp. All rights reserved.
//

import Foundation

protocol Create {}

extension Create where Self: NSObject {
    @discardableResult
    static func create(_ closure: (Self) -> Void) -> Self {
        let object = Self()
        closure(object)
        return object
    }
}
