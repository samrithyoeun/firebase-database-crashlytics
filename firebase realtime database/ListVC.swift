//
//  ViewController.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/2/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Crashlytics

class ListVC: UITableViewController {
    
    var listItem = [Item]()
    let reference = Database.database().reference().child("list-items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retreiveData()
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listItem[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeItem = listItem[indexPath.row]
            listItem.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reference.child(removeItem.key).removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateData(listItem[indexPath.row])
    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        setUpAddItemAlert()
    }
    
    @IBAction func crashButtonTouched(_ sender: Any) {
         Crashlytics.sharedInstance().crash()
    }
    
    
    private func setUpAddItemAlert(){
        let alert = UIAlertController(title: "Add Item", message: "Input your item", preferredStyle: .alert)
        alert.addTextField { (name) in
            name.placeholder = "item name"
        }
        alert .addTextField { (description) in
            description.placeholder = "description"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let itemName = alert.textFields!.first?.text
            let itemDescription = alert.textFields![1].text
            let item = Item(key: " ", name: itemName!, description: itemDescription!)
            self.addData(item)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func retreiveData () {
        print("get data")
        reference.observe(.value) { (snapshot) in
            var list = [Item]()
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot {
                    print(snapshot.key)
                    let key = snapshot.key
                    let name = snapshot.childSnapshot(forPath: "name").value as? String
                    let description = snapshot.childSnapshot(forPath: "description").value as? String
                    let item = Item(key: key, name: name!, description: description!)
                    list.append(item)
                    print(item)
                    
                }
            }
            self.listItem = list
            print("size of table is \(list.count)")
            self.tableView.reloadData()
        }
       
    }
    
    private func addData(_ item: Item){
      
        let key = reference.childByAutoId().key
        reference.child(key).setValue(item.getData())
    }
    
    private func updateData(_ item: Item){
        let alert = UIAlertController(title: item.name, message: "Update the data", preferredStyle: .alert)
        alert.addTextField { (name) in
            name.text = item.name
            
        }
        alert .addTextField { (description) in
            description.text = item.description
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            let itemName = alert.textFields!.first?.text
            let itemDescription = alert.textFields![1].text
            let newItemData = Item(key: " ", name: itemName!, description: itemDescription!)
            self.reference.child(item.key).updateChildValues(newItemData.getData())
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

