//
//  CoreDataManager.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/13.
//

import Foundation
import CoreData

// MARK: - Properties

final class CoreDataManager {
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    var count = [String]()
    var countTrack = 0
    
    var users: [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        guard let users = try? managedObjectContext.fetch(request) else { return [] }
        return users
    }
    
    // MARK: - Initializer
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    func loadNumberOfElements() {
        let trackController = TrackHistoryTableViewController()
        for track in users {
            print("Looping sessions \(track.locations as Any)")
            count.append("\(countTrack + 1)")
            trackController.paceNumber.append("0")
            print("corDatMAnager \(trackController.paceNumber)")
            guard let last = count.last else { return }
            guard let lastAsInt = Int(last) else { return }
            countTrack = lastAsInt
        }
    }
    
    func newSession() {
        let user = UserEntity(context: managedObjectContext)
        user.locations = [CLLocation]()
        user.pace = ""
    }

    func saveTrack(numberOfPace: String, locations: [CLLocation]) {
        let user = UserEntity(context: managedObjectContext)
        user.pace = numberOfPace
        user.locations = locations
        user.timestamp = locations.last?.timestamp
        coreDataStack.saveContext()
    }
}
