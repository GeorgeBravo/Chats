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
        return DateFormatter.timeHoursDateFormatter.string(from: self)
    }
    
    var headerSectionDate: String {
        return DateFormatter.namedMonthFormatFormatter.string(from: self)
    }
    
    func createdDateText(onlyTime: Bool = false, withTodayCheck: Bool = true, slashedDate: Bool = false) -> (dateText: String, isWeekend: Bool) {
        let calendar = Calendar.autoupdatingCurrent
        if (calendar.isDateInToday(self) && withTodayCheck) || onlyTime {
            return (DateFormatter.timeHoursDateFormatter.string(from: self), false)
        } else if self.isInLastWeek() {
            return (DateFormatter.shortDateFormatter.string(from: self), calendar.isDateInWeekend(self))
        } else {
            return (DateFormatter.daySlashMonthFormatFormatter.string(from: self), false)
        }
    }
    
}

extension Date {
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func isInLastWeek() -> Bool {
        guard let weekAgoDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return false }
        return weekAgoDate <= self
    }
}
