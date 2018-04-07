//
//  Category.swift
//  11_TodoeyRealm
//
//  Created by Max Kraev on 06/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    
    var items = List<ToDoItem>()
}
