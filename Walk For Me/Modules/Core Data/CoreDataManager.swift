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
    
    var game: [GameEntity] {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        guard let users = try? managedObjectContext.fetch(request) else { return [] }
        return users
    }
    
    // MARK: - Initializer
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Track

    func saveTrack(numberOfPace: String, locations: [CLLocation]) {
        let track = TrackEntity(context: managedObjectContext)
        track.totalPace = numberOfPace
        track.locations = locations
        track.timestamp = locations.last?.timestamp
        coreDataStack.saveContext()
    }
    
    func clearTracks() {
        tracks.forEach { managedObjectContext.delete($0)}
        coreDataStack.saveContext()
    }
    
    // MARK: - Game
    func savePace(paceAmount: String?, moneyAmount: String) {
        let game = GameEntity(context: managedObjectContext)
        game.paceAmount = paceAmount
        game.moneyAmount = moneyAmount
        coreDataStack.saveContext()
    }
    
    func saveMoney(moneyamount: String, paceAmount: String) {
            let game = GameEntity(context: managedObjectContext)
            game.moneyAmount = moneyamount
            game.paceAmount = paceAmount
            coreDataStack.saveContext()
    }
    func deleteTrack() {
        game.forEach { managedObjectContext.delete($0)}
        coreDataStack.saveContext()
    }
}
