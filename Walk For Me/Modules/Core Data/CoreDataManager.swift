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
    
    var users: [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        guard let users = try? managedObjectContext.fetch(request) else { return [] }
        return users
    }

    func savePace(numberOfPace: String) {
        let user = User(context: managedObjectContext)
        user.pace = numberOfPace
        coreDataStack.saveContext()
    }
}
