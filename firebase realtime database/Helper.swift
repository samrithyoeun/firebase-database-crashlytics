//
//  Helper.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/3/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

func setUpUpdateAlert(of item: Item, completion: @escaping (Item) -> () ){
    let alert = UIAlertController(title: "Update", message: "Update the data", preferredStyle: .alert)
    alert.addTextField { (name) in
        name.text = item.name
        
    }
    alert .addTextField { (description) in
        description.text = item.description
    }
    alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
        
        let itemName = alert.textFields!.first?.text
        let itemDescription = alert.textFields![1].text
        let newItemData = Item(key: item.key, name: itemName!, description: itemDescription!)
        completion(newItemData)
        
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}

func setUpAddItemAlert(completion: @escaping (Item) -> ()){
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
        completion(item)
        
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
}


func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


