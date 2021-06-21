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
    func saveData(paceAmount: String) {
        if game == nil {
            let newGame = GameEntity(context: managedObjectContext)
            newGame.paceAmount = paceAmount
            coreDataStack.saveContext()
            
        } else {
            guard let currentGame = game else { return }
            currentGame.paceAmount = paceAmount
            coreDataStack.saveContext()
        }
    }
    
    func saveVegetable(vegetableType: String, vegetableAmount: String, moneyAmount: String, isPlanting: Bool) {
        guard let currentGame = game else { return }
        
        guard var wheatAmount = Int(currentGame.wheatAmount ?? "0") else { return }
        guard var potatoeAmount = Int(currentGame.potatoeAmount ?? "0") else { return }
        guard var tomatoeAmount = Int(currentGame.tomatoeAmount ?? "0") else { return }
        
        switch vegetableType {
        case Constant.wheat:
            if isPlanting {
                currentGame.wheatAmount = "\(vegetableAmount)"
            } else { wheatAmount += Int(vegetableAmount) ?? 0
                currentGame.wheatAmount = "\(wheatAmount)"
                currentGame.paceAmount = moneyAmount
            }
            
        case Constant.potatoe:
            if isPlanting { currentGame.potatoeAmount = "\(vegetableAmount)"
            } else { potatoeAmount += Int(vegetableAmount) ?? 0
                currentGame.potatoeAmount = "\(potatoeAmount)"
                currentGame.paceAmount = moneyAmount
            }
            
        case Constant.tomatoe:
            if isPlanting { currentGame.tomatoeAmount = "\(vegetableAmount)"
            } else { tomatoeAmount += Int(vegetableAmount) ?? 0
                currentGame.tomatoeAmount = "\(tomatoeAmount)"
                currentGame.paceAmount = moneyAmount
            }
        default:
            break
        }
        coreDataStack.saveContext()
    }
    
    func saveCell(images: [String]) {
        guard let currentGame = game else { return }
        currentGame.imagesCell = images
        coreDataStack.saveContext()
    }
    
    func removeImageAndTime(index: Int) {
        guard let currentGame = game else { return }
        currentGame.gardenTimeInterval?.remove(at: index)
        currentGame.imagesCell?.remove(at: index)
        coreDataStack.saveContext()
    }
    
    func saveTimeInterval(gardenTimeInterval: [String]) {
        guard let currentGame = game else { return }
        currentGame.gardenTimeInterval = gardenTimeInterval
        coreDataStack.saveContext()
    }
}
