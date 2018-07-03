//
//  File.swift
//  firebase realtime database
//
//  Created by PM Academy 3 on 7/2/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation
struct Item {
    var key: String
    var name: String
    var description: String
    
    func getData() -> [String: String]{
        return ["name": name, "description": description]
    }
    
}
