//
//  Date+.swift
//  Chats
//
//  Created by Касилов Георгий on 02.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

extension Date {
    var shortDate: NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringDate = dateFormatter.string(from: self)
        return NSAttributedString(string: stringDate)
    }
}
