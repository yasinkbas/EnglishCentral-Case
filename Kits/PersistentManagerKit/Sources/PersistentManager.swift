//
//  PersistentManager.swift
//  PersistentManagerKit
//
//  Created by Yasin Akbas on 20.07.2022.
//  Copyright © 2022 com.yasinkbas.PersistentManagerKit. All rights reserved.
//

import CoreData

public protocol PersistentManagerInterface: AnyObject {
    static func managedObjectContext(container: CoreDataContainer) -> NSManagedObjectContext
    static func saveContext(container: CoreDataContainer)
}

private extension PersistentManager {
    enum Constant {
        static let storeCoordinatorOptions: [AnyHashable: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
    }
}

public class PersistentManager: PersistentManagerInterface {
    static var managedObjectContexts: [String : NSManagedObjectContext] = [:]
    
    public static func managedObjectContext(container: CoreDataContainer) -> NSManagedObjectContext {
        if let managedObjectContext = managedObjectContexts[container.name] {
            return managedObjectContext
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator(container: container)
        managedObjectContexts[container.name] = managedObjectContext
        return managedObjectContext
    }
    
    private static func managedObjectModel(container: CoreDataContainer) -> NSManagedObjectModel {
        guard let modelURL = Bundle(for: Self.self).url(forResource: container.name, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }
    
    private static func persistentStoreCoordinator(container: CoreDataContainer) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel(container: container))
        
        let fileManager = FileManager.default
                                                                      let storeName = "\(container.name).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: Constant.storeCoordinatorOptions)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return persistentStoreCoordinator
    }
    
    public static func saveContext(container: CoreDataContainer) {
        guard managedObjectContext(container: container).hasChanges else { return }
        do {
            try managedObjectContext(container: container).save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
