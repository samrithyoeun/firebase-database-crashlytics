//
//  ItemRealm.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/3/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmService: Object {
    @objc dynamic var key = ""
    @objc dynamic var name = ""
    @objc dynamic var descriptions = ""
    
     func setValue(item: Item){
        self.key = item.key
        self.name = item.name
        self.descriptions = item.description
    }
    
     func map() -> Item {
        
        let item = Item(key: self.key, name: self.name, description: self.descriptions)
        return item
    }
    
    static func insert(_ item: Item){
        let object = RealmService()
        object.setValue(item: item)
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func getAll() -> [Item] {
        let realm = try! Realm()
        let items = realm.objects(RealmService.self)
        var listItem = [Item]()
        print(items)
        for item in items {
            listItem.append(item.map())
        }
        return listItem
    }
    
    static func delete(_ item: Item){
        let realm = try! Realm()
        let objects = realm.objects(RealmService.self).filter("key = %@", item.key)
        print(objects)
        if let object = objects.first {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    static func deleteAll(){
        
        let realm  = try! Realm()
        try! realm.write {
            realm.deleteAll()
            
        }
    }
    
    static func save(_ list: [Item]){
        deleteAll()
        for item in list {
            insert(item)
        }
    }
    
    static func update(_ item: Item){
        let realm = try! Realm()
        let objects = realm.objects(RealmService.self).filter("key = %@", item.key)
        print(objects)
        if let object = objects.first {
            try! realm.write {
                object.name = item.name
                object.descriptions = item.description
            }
        }
    }
}
