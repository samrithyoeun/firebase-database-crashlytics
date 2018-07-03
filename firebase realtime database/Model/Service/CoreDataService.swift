//
//  ItemsCoreData.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/3/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataService{
    static let managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()
    
    static let entityName = "Items"
    
    static func findItemsBy(key: String) -> NSObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "key = '\(key)' ")
        let result = try? managedContext.fetch(fetchRequest)[0]
        return result
    }
    
    static func insert(_ item: Item){
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let entityItem = NSManagedObject(entity: entity, insertInto: managedContext)
        entityItem.setValue(item.key, forKey: "key")
        entityItem.setValue(item.name, forKey: "name")
        entityItem.setValue(item.description, forKey: "descriptions")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("error core data : \(error), \(error.userInfo)")
        }
        
    }
    
    static func retreiveData() -> [Item] {
        var listItems = [NSManagedObject]()
        var result = [Item]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            listItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("error core data fetching : \(error), \(error.userInfo)")
        }
        
        for item in listItems {
            if let key = item.value(forKey: "key") as? String, let name = item.value(forKey: "name") as? String , let description = item.value(forKey: "descriptions") as? String {
                let newItem = Item (key: key, name: name, description: description)
                result.append(newItem)
            }else{
                print("error: item has no value")
            }
        }
        print(result)
        return result
    }
    
    static func update(_ item: Item, by key: String) {
        let result = findItemsBy(key: key)
        result?.setValue(item.name, forKey: "name")
        result?.setValue(item.description, forKey: "descriptions")
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("error: Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func delete(_ item: Item){
        let result = findItemsBy(key: item.key)
        managedContext.delete(result as! NSManagedObject)
        do {
            try managedContext.save()
            print("deleted!")
        } catch let error as NSError  {
            print("error: Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}

