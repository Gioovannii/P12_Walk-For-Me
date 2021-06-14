//
//  String + Formatter.swift
//  Walk_For_Me
//
//  Created by Giovanni Gaffé on 2021/6/13.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
}
