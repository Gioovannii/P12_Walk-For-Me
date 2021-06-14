//
//  DateFormater + convertUTCTime.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/10.
//

import Foundation

extension DateFormatter {
    
    static func getDateToString(from: Date, dateStyle: Style, timeStyle: Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
       
        return dateFormatter.string(from: from)
    }
}
