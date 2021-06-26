//
//  CoreDataManagerTestcase.swift
//  Walk_For_MeTests
//
//  Created by Giovanni Gaffé on 2021/6/24.
//

import Walk_For_Me
import CoreData

final class MockCoreDataStack: CoreDataStack {
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(modelName: "Walk_For_Me")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
