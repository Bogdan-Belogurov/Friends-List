//
//  CoreDataStack.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 20/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

protocol EntityFetchable {
    static var entityName: String { get }
}

protocol ICoreDataStack {
    func performSave(in context: NSManagedObjectContext, completion: ((Error?) -> Void)?)
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
    
    func deleteAllDataFrom(_ entity: String, in context: NSManagedObjectContext, completion: @escaping (Bool) -> Void)
    func find<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, with predicate: NSPredicate?) -> T? where T: EntityFetchable
    func findAll<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> [T] where T: EntityFetchable
    func delete<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, with predicate: NSPredicate?) -> Bool where T: EntityFetchable
}

internal final class CoreDataStack: ICoreDataStack {
    
    private lazy var storeURL: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docUrl = url.appendingPathComponent("FriendsList.sqlite")
        return docUrl
    }()
    
    private lazy var objectModel: NSManagedObjectModel = {
        guard let mom = Bundle.main.url(forResource: "FriendsList",
                                        withExtension: "momd") else { fatalError("Can't search the resource") }
        guard let objectModel = NSManagedObjectModel(contentsOf: mom)
            else { fatalError("Can't search the object model by this url: \(mom)") }
        return objectModel
    }()
    
    private lazy var persistentCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil, at: storeURL, options: options)
        } catch let error {
            assertionFailure("Error due try to add store at \(storeURL) with description \(error.localizedDescription)")
        }
        return coordinator
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = masterContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()
    
    private lazy var masterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentCoordinator
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()
    
    public func deleteAllDataFrom(_ entity: String, in context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        context.performAndWait {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try context.execute(deleteRequest)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    public func performSave(in context: NSManagedObjectContext, completion: ((Error?) -> Void)?) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    completion?(error)
                }
                if let parentContext = context.parent {
                    self.performSave(in: parentContext, completion: completion)
                } else {
                    completion?(nil)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    public func find<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, with predicate: NSPredicate?) -> T? where T: EntityFetchable {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        let savedEntities = try? context.fetch(request)
        return savedEntities?.first
    }
    
    public func findAll<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> [T] where T: EntityFetchable {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptor
        let fetchedEntities = try? context.fetch(request)
        return fetchedEntities ?? []
    }
    
    public func delete<T: NSManagedObject>(_ object: T.Type, in context: NSManagedObjectContext, with predicate: NSPredicate?) -> Bool where T: EntityFetchable {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        request.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            return true
        } catch {
            return false
        }
    }
}
