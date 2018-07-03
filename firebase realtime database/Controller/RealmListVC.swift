//
//  RealmListVC.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/3/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import Firebase


class RealmListVC: UITableViewController {
    var listItem = [Item]()
    let reference = Database.database().reference().child("list-items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        switch isConnectedToNetwork() {
        case true:
            FirebaseService.getAllData(completion: ({ (list) in
                self.listItem = list
                self.tableView.reloadData()
                RealmService.save(self.listItem)
            }))
        case false:
            listItem = RealmService.getAll()
            tableView.reloadData()
        }
       
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let item = listItem[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeItem = listItem[indexPath.row]
            listItem.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            FirebaseService.delete(removeItem)
            RealmService.delete(removeItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listItem[indexPath.row]
        setUpUpdateAlert(of: item, completion:{ item in
            FirebaseService.update(item)
            self.listItem[indexPath.row] = item
            RealmService.update(item)
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        setUpAddItemAlert(completion:{ item in
            FirebaseService.add(item)
            RealmService.insert(item)
            self.listItem.append(item)
            self.tableView.reloadData()
        })
    }
    
   
    
}
