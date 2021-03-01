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
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    var users: [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        guard let users = try? managedObjectContext.fetch(request) else { return [] }
        return users
    }

    func savePace(numberOfPace: String) {
        let user = UserEntity(context: managedObjectContext)
        user.pace = numberOfPace
        coreDataStack.saveContext()
    }
}
