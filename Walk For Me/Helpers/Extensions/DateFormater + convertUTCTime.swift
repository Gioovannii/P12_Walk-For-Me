//
//  DateFormater + convertUTCTime.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/10.
//

import Foundation

extension DateFormatter {
    
    static func localizedDate(from: Date, dateStyle: Style, timeStyle: Style) -> String {
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.formatterBehavior = .behavior10_4
        utcDateFormatter.dateStyle = dateStyle
        utcDateFormatter.timeStyle = timeStyle
        utcDateFormatter.timeZone = .autoupdatingCurrent
        return utcDateFormatter.string(from: from)
//        return utcDateFormatter.date(from: formatDate)!
    }
}
