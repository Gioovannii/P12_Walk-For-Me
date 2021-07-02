//
//  DateFormatterTestCase.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/25.
//

@testable import Walk_For_Me
import XCTest
import CoreLocation

class DateFormatterTestCase: XCTestCase {

    let dateString = "2021-06-26, 17:54:45 +08:00 "
    func testGetDateFromString() {
        let date = DateFormatter.getDateFromString(date: dateString)

        XCTAssert(date == DateFormatter.getDateFromString(date: dateString))
        
    }
}
