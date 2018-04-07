//
//  Item.swift
//  11_TodoeyRealm
//
//  Created by Max Kraev on 06/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var subTitle: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
