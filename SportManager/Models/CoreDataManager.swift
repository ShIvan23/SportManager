//
//  CoreDataManager.swift
//  SportManager
//
//  Created by Ivan on 30.01.2021.
//

import CoreData

final class CoreDataManager {
    
    // MARK: - Private Properties
    private let modelName: String
    
    // MARK: - Initializers
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - CoreData Stack initialisation
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { (storeDesctiption, error) in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print(error.localizedDescription)
            }
        }
    }
    
    func createObject<T: NSManagedObject>(from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil) -> [T] {
        let context = getContext()
        
        let request: NSFetchRequest<T>
        var fetchedResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            let entityName = String(describing: entity)
            request = NSFetchRequest(entityName: entityName)
        }
        
        let playerSortDescriptor = NSSortDescriptor(key: "fullName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        request.predicate = predicate
        request.sortDescriptors = [playerSortDescriptor]
        
        do {
            fetchedResult = try context.fetch(request)
            
        } catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
        }
        
        return fetchedResult
    }
    
}
