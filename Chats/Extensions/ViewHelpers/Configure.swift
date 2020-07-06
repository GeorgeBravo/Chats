//
//  Configure.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2019 RestySpp. All rights reserved.
//

import Foundation

protocol Configure {}

extension Configure where Self: Any {
    @discardableResult
    func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
