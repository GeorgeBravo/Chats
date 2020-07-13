//
//  Date+.swift
//  Chats
//
//  Created by Касилов Георгий on 02.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

extension Date {
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: self)
    }
    
    var headerSectionDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
//        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: self)
    }
}
