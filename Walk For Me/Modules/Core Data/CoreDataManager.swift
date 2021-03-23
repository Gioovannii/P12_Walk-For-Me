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
    
    var tracks: [TrackEntity] {
        let request: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        guard let users = try? managedObjectContext.fetch(request) else { return [] }
        return users
    }
    
    // MARK: - Initializer
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    func newSession() {
        let user = TrackEntity(context: managedObjectContext)
        user.locations = [CLLocation]()
        user.totalPace = "0"
        coreDataStack.saveContext()
    }

    func saveTrack(numberOfPace: String, locations: [CLLocation]) {
        let request: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        
        //request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let user = try? managedObjectContext.fetch(request) else { return }
        guard let session = user.first else { return }
        session.totalPace = numberOfPace
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
