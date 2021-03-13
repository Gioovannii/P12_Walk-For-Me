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
        let id = UUID().uuidString
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let user = try? managedObjectContext.fetch(request) else { return }
        guard let session = user.first else { return }
        session.pace = numberOfPace
        session.locations = locations
        session.timestamp = locations.last?.timestamp
        coreDataStack.saveContext()
        
//        let user = UserEntity(context: managedObjectContext)
////        user.id =
//        user.pace = numberOfPace
//        user.locations = locations
//        user.timestamp = locations.last?.timestamp
//        coreDataStack.saveContext()
    }
}
