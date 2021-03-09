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
    
//    var count = [String]()
//    var countTrack = 0
    
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

    func newSession() {
        let user = UserEntity(context: managedObjectContext)
        user.locations = [CLLocation]()
        user.pace = ""
        coreDataStack.saveContext()
    }

    func saveTrack(numberOfPace: String, locations: [CLLocation]) {
        let user = UserEntity(context: managedObjectContext)
        user.pace = numberOfPace
        user.locations = locations
        user.timestamp = locations.last?.timestamp
        coreDataStack.saveContext()
    }
}
