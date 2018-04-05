//
//  DataModel.swift
//  10_Todoey
//
//  Created by Max Kraev on 05/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation

class ToDoItem: Codable {
    
    var title: String = ""
    var subTitile: String = ""
    var done: Bool = false
    
}
