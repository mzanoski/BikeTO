//
//  DataController.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-03-08.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation
import CoreData
enum EntityType: String{
    case Recent = "Recent"
    case Favorite = "Favorite"
}

class DataController {
    let managedObjectContext: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext){
        self.managedObjectContext = moc
    }
    
    convenience init?(){
        guard let modelUrl = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
            return nil
        }
        
        guard let mom = NSManagedObjectModel(contentsOfURL: modelUrl) else {
            return nil
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let persistentStoreFileUrl = urls[0].URLByAppendingPathComponent("Locations.sqllite")
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistentStoreFileUrl, options: nil)
        }
        catch {
            fatalError("Error adding store.")
        }
        
        self.init(moc: moc)
    }
    
    func addLocation(id: Int, entityType: EntityType){
        let fetchRequest = NSFetchRequest(entityName: entityType.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        var fetchedItems: [Int]!
        
        do{
            fetchedItems = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Int]
        }
        catch {
            fatalError("fetching \(entityType) with id \(id) failed")
        }
        
        if fetchedItems.count == 0 {
            if entityType == EntityType.Favorite {
                let item = NSEntityDescription.insertNewObjectForEntityForName(entityType.rawValue, inManagedObjectContext: self.managedObjectContext) as! Favorite
                item.id = id
            }
            else if entityType == EntityType.Recent {
                let item = NSEntityDescription.insertNewObjectForEntityForName(entityType.rawValue, inManagedObjectContext: self.managedObjectContext) as! Recent
                item.id = id
            }
        }
        
        do{
            try self.managedObjectContext.save()
        }
        catch{
            fatalError("saving context failed!")
        }
    }
    
    func hasLocation(id: Int, entityType: EntityType) -> Bool{
        let fetchRequest = NSFetchRequest(entityName: entityType.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        var fetchedItems: [AnyObject]!
        
        do{
            fetchedItems = try self.managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch {
            fatalError("fetching \(entityType) with id \(id) failed")
        }
        
        if fetchedItems.count != 0 {
            return true
        }
        return false
    }
    
    func removeLocation(id: Int, entityType: EntityType) -> Bool{
        let fetchRequest = NSFetchRequest(entityName: entityType.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        var fetchedItems: [AnyObject]!
        
        do{
            fetchedItems = try self.managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch {
            fatalError("fetching \(entityType) with id \(id) failed")
        }
        
        if fetchedItems.count != 0 {
            self.managedObjectContext.deleteObject(fetchedItems[0] as! NSManagedObject)
            
            do{
                try self.managedObjectContext.save()
                return true
            }
            catch{
                fatalError("could not save managed context after deleting item!")
            }
        }
        return false
    }
    
    func getLocation(id: Int, entityType: EntityType) -> Any?{
        let fetchRequest = NSFetchRequest(entityName: entityType.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        var fetchedItems: [AnyObject]!
        
        do{
            fetchedItems = try self.managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch {
            fatalError("fetching \(entityType) with id \(id) failed")
        }
        
        if fetchedItems.count != 0 {
            return fetchedItems[0]
        }
        return nil
    }
}
