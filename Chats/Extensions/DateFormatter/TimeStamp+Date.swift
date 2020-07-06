//
//  DataFormatter+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import Foundation

extension Int64 {
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
//        formatter.locale = Locale(identifier: "ru_RU")

        let date = Date(timeIntervalSince1970: TimeInterval(self))

        return formatter.string(from: date)
    }
}
