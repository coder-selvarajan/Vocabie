//
//  BaseModel.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation
import CoreData

protocol BaseModel where Self: NSManagedObject {
    func save()
    func delete()
    static func byId<T: NSManagedObject>(id: NSManagedObjectID) -> T?
    static func all<T: NSManagedObject>() -> [T]
}

extension BaseModel {
    
    static var viewContext: NSManagedObjectContext {
        return CoreDataProvider.shared.viewContext
    }
    
    func save() {
        do {
            try Self.viewContext.save()
        } catch {
            Self.viewContext.rollback()
            print(error)
        }
    }
    
    func delete() {
        Self.viewContext.delete(self)
        save()
    }
    
    static func all<T>() -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        let sort = NSSortDescriptor(key: #keyPath(UserWord.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func all<T>(sortBy sortDescriptor: NSSortDescriptor) -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func getRecentRecords<T>(limit: Int) -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.fetchOffset = 0;
        fetchRequest.fetchLimit = limit;
        
        let sort = NSSortDescriptor(key: #keyPath(UserWord.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func getRecentFiveRecords<T>() -> [T] where T: NSManagedObject {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.fetchOffset = 0;
        fetchRequest.fetchLimit = 5;
        
        let sort = NSSortDescriptor(key: #keyPath(UserWord.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func byDate<T>(dat: String) -> [T] where T: NSManagedObject {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        let fromdate = "\(dat) 00:00" // add hours and mins to fromdate
        let todate = "\(dat) 23:59" // add hours and mins to todate
        
        fetchRequest.returnsObjectsAsFaults = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        let startDate:NSDate = dateFormatter.date(from: fromdate)! as NSDate
        let endDate:NSDate = dateFormatter.date(from: todate)! as NSDate
        fetchRequest.predicate = NSPredicate(format: "(creationDate >= %@) AND (creationDate <= %@)", startDate, endDate)

        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func byId<T>(id: NSManagedObjectID) -> T? where T: NSManagedObject {
        
        do {
            return try viewContext.existingObject(with: id) as? T
        } catch {
            print(error)
            return nil
        }
    }
}
