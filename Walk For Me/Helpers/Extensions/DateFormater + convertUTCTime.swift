//
//  DateFormater + convertUTCTime.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/10.
//

import Foundation

extension DateFormatter {
    
    static func getDateToString(from: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd', 'HH:mm:ss ZZZZZ "
        
        return dateFormatter.string(from: from)
    }
    
    
    static func getDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+8")
        dateFormatter.dateFormat = "yyyy-MM-dd', 'HH:mm:ss ZZZZZ"
        guard let date = dateFormatter.date(from:date) else { fatalError(#function, file: #file, line: #line) }
        return date
    }
}
