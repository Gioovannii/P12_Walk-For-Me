//
//  AlertController.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/25.
//

@testable import Walk_For_Me
import XCTest

class AlertController: XCTestCase {
    
    func testAlert() {
        UIViewController().presentAlert(title: "Alert", message: "Ok", actionTitle: "OK")
        
    }

}
