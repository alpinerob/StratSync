//
//  CoreDataManager.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmallBusinessCompass")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("CoreData store failed to load: \(error), \(error.userInfo)")
                fatalError("CoreData store failed to load: \(error), \(error.userInfo)")
            } else {
                print("✅ CoreData store loaded successfully")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Failed to save context: \(nserror), \(nserror.userInfo)")
                #if DEBUG
                // In debug, crash to make errors obvious during development
                fatalError("Development error: Failed to save context: \(nserror), \(nserror.userInfo)")
                #endif
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    // Create
    func createEntity<T: NSManagedObject>(_ type: T.Type) -> T {
        let entityName = String(describing: type)
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
        return entity
    }
    
    // Fetch all
    func fetchEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let entityName = String(describing: type)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
    
    // Delete
    func deleteEntity(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
