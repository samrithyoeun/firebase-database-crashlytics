//
//  FirebaseService.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/3/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService{
    static let reference = Database.database().reference().child("list-items")
   
    static func getAllData (completion: @escaping ([Item])->()){
        print("firebase service is getting the data")
        reference.observe(.value) { (snapshot) in
          var list = [Item]()
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot {
                    let key = snapshot.key
                    let name = snapshot.childSnapshot(forPath: "name").value as? String
                    let description = snapshot.childSnapshot(forPath: "description").value as? String
                    let item = Item(key: key, name: name!, description: description!)
                    list.append(item)
                }
            }
            completion(list)
        }
    }
    
    static func add(_ item: Item){
        let key = reference.childByAutoId().key
        reference.child(key).setValue(item.getData())
    }
    
    static func update(_ item: Item){
        reference.child(item.key).updateChildValues(item.getData())
    }
    
    static func delete(_ item: Item){
        reference.child(item.key).removeValue()
    }
}
