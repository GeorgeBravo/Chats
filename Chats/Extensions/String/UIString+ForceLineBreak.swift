//
//  UIString+ForceLineBreak.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 1/2/20.
//  Copyright © 2020 Stream LLC. All rights reserved.
//

import Foundation

extension String {
    func forceLineBreak() -> String {
        return self.replacingOccurrences(of: " ", with: "\n")
    }
}
