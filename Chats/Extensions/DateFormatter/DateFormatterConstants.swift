//
//  DateFormatterConstants.swift
//  Chats
//
//  Created by user on 24.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import Foundation

enum DateFormatConstants {
    
    static let iso8601Full = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

    static var timeDayMonthYearDateFormat: String {
        return "HH:mm dd/MM/yyyy"
    }

    static var timeHoursFormatter: String {
        return "h:mm a"
    }
    
    static var daySlashMonthSlashYearFormat: String {
        return "dd/MM/yy"
    }
    
    static var dayMonthYearDateFormat: String {
        return "dd MM yyyy"
    }
    
    static var dateCreationDateCurrentYearFormat: String {
        return "EEE, MMM, dd"
    }
    
    static var dateCreationDateYearFormat: String {
        return "EEE, MMM, dd, yyyy"
    }

    static var shortDateFormat: String {
        return "EEE"
    }
    
    static var daySlashMonthFormat: String {
        return "dd/MM"
    }
    
    static var namedMonthFormat: String {
        return "MMM d"
    }
    
}
