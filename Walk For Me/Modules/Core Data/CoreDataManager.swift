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
    
    var game: GameEntity? {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        guard let games = try? managedObjectContext.fetch(request) else { return nil }
        
        guard let game = games.first else { return nil }
        return game
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
    func saveData(paceAmount: String, moneyAmount: String) {
        if game == nil {
            let newGame = GameEntity(context: managedObjectContext)
            newGame.moneyAmount = moneyAmount
            newGame.paceAmount = paceAmount
            coreDataStack.saveContext()

        } else {
            guard let currentGame = game else { return }
            currentGame.moneyAmount = moneyAmount
            currentGame.paceAmount = paceAmount
            coreDataStack.saveContext()
        }
    }
    
    func deleteTrack() {
        guard let currentGame = game else { return }
        managedObjectContext.delete(currentGame)
        coreDataStack.saveContext()
    }
    
    func saveVegetable(vegetableType: String, vegetableAmount: String, moneyAmount: String) {
        guard let currentGame = game else { return }
        
        guard var wheatAmount = Int(currentGame.wheatAmount ?? "0") else { return }
        guard var potatoeAmount = Int(currentGame.potatoeAmount ?? "0") else { return }
        guard var tomatoeAmount = Int(currentGame.tomatoeAmount ?? "0") else { return }
        
        switch vegetableType {
        case "céréales":
            wheatAmount += Int(vegetableAmount) ?? 0
            currentGame.moneyAmount = moneyAmount
        case "pomme de terre":
            potatoeAmount += Int(vegetableAmount) ?? 0
          
        default:
            break
        }
        coreDataStack.saveContext()
    }
}
