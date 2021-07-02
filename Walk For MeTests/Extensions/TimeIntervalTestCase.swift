//
//  TimeIntervalTestCase.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/25.
//

@testable import Walk_For_Me
import XCTest

class TimeIntervalTestCase: XCTestCase {
    
    func testTimeIntervalToInt() {
        let firstDateTime = Date(timeIntervalSinceReferenceDate: 650000000.0)
        let secondDate = Date(timeIntervalSinceReferenceDate: 65050000.0)
        
        let timeInterval = firstDateTime.timeIntervalSince(secondDate)
        let date = timeInterval.intFromTimeInterval()
        XCTAssert(date == 6)
    }
}
