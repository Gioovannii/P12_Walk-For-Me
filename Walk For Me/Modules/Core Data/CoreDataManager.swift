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

        let track = TrackEntity(context: managedObjectContext)
        track.totalPace = numberOfPace
        track.locations = locations
        track.timestamp = locations.last?.timestamp
        coreDataStack.saveContext()
    }
}
