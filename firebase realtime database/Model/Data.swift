//
//  Data.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/2/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Data{
    static func loadData(to tableView : UITableView) -> [Item]{
        print("get data")
        var listItem = [Item]()
        let reference = Database.database().reference()
        
        reference.child("list-items").observe(.value) { (snapshot) in
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot {
                    print(snapshot)
                    let name = snapshot.childSnapshot(forPath: "name").value as? String
                    let description = snapshot.childSnapshot(forPath: "description").value as? String
                    let item = Item(key: "", name: name!, description: description!)
                    listItem.append(item)
                    print(item)
                    print("size of table is \(listItem.count)")
                    tableView.reloadData()
                }
            }
        }
        return listItem
    }
}
