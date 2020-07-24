//
//  DataFormatter+.swift
//  Cc Dns
//
//  Created by Касилов Георгий on 3/31/20.
//  Copyright © 2020 RestySpp. All rights reserved.
//

import Foundation

extension DateFormatter {

    // MARK: - "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatConstants.iso8601Full
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // MARK: - "HH:mm dd/MM/yyyy"
    static let timeDayMonthYearDateFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.timeDayMonthYearDateFormat)
        _timeDayMonthYearDateFormatter = formatter
        return formatter
    }()
    private static var _timeDayMonthYearDateFormatter: DateFormatter?
    
    // MARK: - "h:mm a"
    static let timeHoursDateFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.timeHoursFormatter)
        _timeHoursDateFormatter = formatter
        return formatter
    }()
    private static var _timeHoursDateFormatter: DateFormatter?
    
    // MARK: - "dd/MM/yy"
    static let daySlashMonthSlashYearDateFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.daySlashMonthSlashYearFormat)
        _daySlashMonthSlashYearDateFormatter = formatter
        return formatter
    }()
    private static var _daySlashMonthSlashYearDateFormatter: DateFormatter?

    // MARK: - "dd MM yyyy"
    static let dayMonthYearFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.dayMonthYearDateFormat)
        _dayMonthYearFormatter = formatter
        return formatter
    }()
    private static var _dayMonthYearFormatter: DateFormatter?

    // MARK: - "EEE, MMM, dd"
    static let creationDateCurrentYearFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.dateCreationDateCurrentYearFormat)
        _currentYearCreationFormatter = formatter
        return formatter
    }()
    private static var _currentYearCreationFormatter: DateFormatter?

    // MARK: - "EEE, MMM, dd, yyyy"
    static let creationDateYearFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.dateCreationDateYearFormat)
        _yearCreationFormatter = formatter
        return formatter
    }()
    private static var _yearCreationFormatter: DateFormatter?
    
    // MARK: - "EEE"
    static let shortDateFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.shortDateFormat)
        _shortDateFormatter = formatter
        return formatter
    }()
    private static var _shortDateFormatter: DateFormatter?

    // MARK: - "dd/MM"
    static let daySlashMonthFormatFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.daySlashMonthFormat)
        _daySlashMonthFormatFormatter = formatter
        return formatter
    }()
    private static var _daySlashMonthFormatFormatter: DateFormatter?
    
    // MARK: - "MMM d"
    static let namedMonthFormatFormatter: DateFormatter = {
        let formatter = dateFormatter(withFormat: DateFormatConstants.namedMonthFormat)
        _namedMonthFormatFormatter = formatter
        return formatter
    }()
    private static var _namedMonthFormatFormatter: DateFormatter?
    
    // MARK: - Supporting logic
    private static func dateFormatter(withFormat format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }
    
    static func reloadDateFormat() {
        _dayMonthYearFormatter?.dateFormat = DateFormatConstants.dayMonthYearDateFormat
        _currentYearCreationFormatter?.dateFormat = DateFormatConstants.dateCreationDateCurrentYearFormat
        _yearCreationFormatter?.dateFormat = DateFormatConstants.dateCreationDateYearFormat
    }
    
}
