//
//  CoreDataManagerTestCase.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/25.
//

@testable import Walk_For_Me
import XCTest
import CoreLocation

class CoreDataManagerTestCase: XCTestCase {

    // MARK: - Properties

    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    
    // MARK: - Tests life cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    
}
