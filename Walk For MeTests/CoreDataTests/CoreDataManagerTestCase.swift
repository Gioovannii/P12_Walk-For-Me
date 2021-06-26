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
    let locations = [CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021988, longitude: -122.02396374), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date()),
                     CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.33021794, longitude: -122.02391316), altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: Date())]
    
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
        coreDataManager.saveTrack(numberOfPace: "0", locations: locations)
        XCTAssert(locations[0].coordinate.latitude == 37.33021988)
        XCTAssertFalse(coreDataManager.tracks.isEmpty)
        
    }
    
    // MARK: - Clear Tracks
    
    func testClearTracks() {
        coreDataManager.saveTrack(numberOfPace: "0", locations: locations)
        coreDataManager.clearTracks()
        XCTAssertTrue(coreDataManager.tracks.isEmpty)
 
    }
    
    // MARK: - Save Data
    
    func testSaveData() {
        coreDataManager.saveData(paceAmount: "50")
        guard let paceAmount = coreDataManager.game?.paceAmount else { return }
        XCTAssertTrue(paceAmount == "50")
        
        coreDataManager.saveData(paceAmount: "100")
        guard let paceAmount = coreDataManager.game?.paceAmount else { return }
        XCTAssertTrue(paceAmount == "100")
    }
    
    // MARK: - Save Vegetable
    
    func testSaveVegetableWheat() {
        coreDataManager.saveData(paceAmount: "200")
        coreDataManager.saveVegetable(vegetableType: Constant.wheat, vegetableAmount: "10", moneyAmount: "100", isPlanting: true)
        XCTAssertTrue(coreDataManager.game?.wheatAmount == "10")
        coreDataManager.saveVegetable(vegetableType: Constant.wheat, vegetableAmount: "10", moneyAmount: "100", isPlanting: false)
        XCTAssert(coreDataManager.game?.wheatAmount == "20")
    }
    
    func testSaveVegetablePotatoe() {
        coreDataManager.saveData(paceAmount: "200")
        coreDataManager.saveVegetable(vegetableType: Constant.potatoe, vegetableAmount: "10", moneyAmount: "100", isPlanting: true)
        XCTAssertTrue(coreDataManager.game?.potatoeAmount == "10")
        coreDataManager.saveVegetable(vegetableType: Constant.potatoe, vegetableAmount: "10", moneyAmount: "100", isPlanting: false)
        XCTAssert(coreDataManager.game?.potatoeAmount == "20")
    }
    
    func testSaveVegetableTomatoe() {
        coreDataManager.saveData(paceAmount: "200")
        coreDataManager.saveVegetable(vegetableType: Constant.tomatoe, vegetableAmount: "10", moneyAmount: "100", isPlanting: true)
        XCTAssertTrue(coreDataManager.game?.tomatoeAmount == "10")
        coreDataManager.saveVegetable(vegetableType: Constant.tomatoe, vegetableAmount: "10", moneyAmount: "100", isPlanting: false)
        XCTAssert(coreDataManager.game?.tomatoeAmount == "20")
    }
    
    func testSaveVegetableEnterBreak() {
        coreDataManager.saveData(paceAmount: "200")
        coreDataManager.saveVegetable(vegetableType: "tomatooes", vegetableAmount: "10", moneyAmount: "100", isPlanting: true)
        
        XCTAssertFalse(coreDataManager.game?.tomatoeAmount == "10")
    }
    
    
    // MARK: - Save cell
    func testSaveCell() {
        coreDataManager.saveData(paceAmount: "100")
        coreDataManager.saveCell(images: [Constant.wheatImage, Constant.potatoeImage, Constant.tomatoeImage])
        
        XCTAssert(coreDataManager.game?.imagesCell?[0] == Constant.wheatImage)
    }
    
    // TODO: - Remove image and time
    
    func testRemoveImageAndTime() {
        coreDataManager.saveData(paceAmount: "100")
        coreDataManager.saveCell(images: [Constant.wheatImage, Constant.potatoeImage, Constant.tomatoeImage])
        coreDataManager.removeImageAndTime(index: 0)
        
        XCTAssert(coreDataManager.game?.imagesCell?.count == 2)
    }
    
    // MARK: - Save time interval
    func testSaveTimeInterval() {
        
        coreDataManager.saveData(paceAmount: "100")

        var gardenTimeInterval = [String]()
        let timeStamp = locations[0].timestamp
        let datetoString = DateFormatter.getDateToString(from: timeStamp)
        gardenTimeInterval.append(datetoString)
        coreDataManager.saveTimeInterval(gardenTimeInterval: gardenTimeInterval)
        
        XCTAssert(coreDataManager.game?.gardenTimeInterval == gardenTimeInterval)
    }
    
    // MARK: - Save experience
    
    func testSaveExperience() {
        coreDataManager.saveData(paceAmount: "10")
        coreDataManager.saveExperience(xp: 10)
        
        XCTAssert(coreDataManager.game?.experience == "10")
    }
}
