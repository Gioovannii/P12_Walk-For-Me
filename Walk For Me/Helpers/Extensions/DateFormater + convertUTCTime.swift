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
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
       
        return dateFormatter.string(from: from)
    }
    
    
    func getDateFromString(isoDate: String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d, y 'at' h:mm:ss a zzzz"
        let date = dateFormatter.date(from:isoDate)!
        return date
    }
}
