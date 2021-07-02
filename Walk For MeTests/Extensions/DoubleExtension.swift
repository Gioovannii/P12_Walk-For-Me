//
//  DoubleExtension.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/25.
//

@testable import Walk_For_Me
import XCTest

class DoubleExtension: XCTestCase {

    let double = 20.0
    func test() {
        let cleanDouble = double.clean
        
        XCTAssert(cleanDouble == "20")
    }
}
