//
//  LCCoreDataStack.swift
//  gu
//
//  Created by tikhonov on 10/9/16.
//  Copyright © 2016 tikhonov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private var modelName = "Teremok"
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator
    var mainManagedObjectContext: NSManagedObjectContext
    
    lazy var applicationDocumentsDirectoryURL: URL = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        return url
    }()
    
    init(completion: @escaping () -> Void) {
        let modelName = self.modelName
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension:"momd") else {
            fatalError("Error loading model \"\(modelName)\" from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        persistentStoreCoordinator = psc
        
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            let storeURL = self.applicationDocumentsDirectoryURL.appendingPathComponent("\(modelName).sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                DispatchQueue.main.sync(execute: completion)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func save() {
        guard mainManagedObjectContext.hasChanges else { return }
        do {
            try mainManagedObjectContext.save()
        } catch let error as NSError {
            print(".save() context. Unresolved error  \(error), \(error.userInfo)")
        }
    }
}
