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
    
    // MARK: - Save tracks

    func testSaveTracks() {
       
        let locations = [CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021988, longitude: -122.02396374), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date()),
                         CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021794, longitude: -122.02391316), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date())]
        
       
        coreDataManager.saveTrack(numberOfPace: "0", locations: locations)
        
        XCTAssertFalse(coreDataManager.tracks.isEmpty)
        
    }
    
    // MARK: - Clear Tracks
    
    func testClearTracks() {
       
        let locations = [CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021988, longitude: -122.02396374), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date()),
                         CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021794, longitude: -122.02391316), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date())]
        
       
        coreDataManager.saveTrack(numberOfPace: "0", locations: locations)
        coreDataManager.clearTracks()
        XCTAssertTrue(coreDataManager.tracks.isEmpty)
 
    }
    
    // MARK: - save Data
    
    func testSaveData() {
       
        coreDataManager.saveData(paceAmount: "50")
        guard let paceAmount = coreDataManager.game?.paceAmount else { return }
        XCTAssertTrue(paceAmount == "50")
        
        coreDataManager.saveData(paceAmount: "100")
        guard let paceAmount = coreDataManager.game?.paceAmount else { return }
        XCTAssertTrue(paceAmount == "100")
    }
    
    // TODO: - save vegetable
    func testSaveVegetable() {
        coreDataManager.saveData(paceAmount: "200")
        coreDataManager.saveVegetable(vegetableType: Constant.wheat, vegetableAmount: "10", moneyAmount: "100", isPlanting: true)
    }
    
    
    // TODO: - Save cell
    
    
    // TODO: - Remove image and time
    
    
    // TODO: - Save time interval
    
    
    // TODO: - Save experience

}
