//
//  TodoListViewController.swift
//  10_Todoey
//
//  Created by Max Kraev on 05/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = ToDoItem()
        item.title = "Add Item"
        item.subTitile = "or not"
        itemArray.append(item)
        
        if let items = defaults.object(forKey: "ToDoListArray") as? [ToDoItem] {
            itemArray = items
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.detailTextLabel?.text = itemArray[indexPath.row].subTitile
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
 
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Add Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add new ToDo", message: nil, preferredStyle: .alert)
        
        ac.addTextField { alertTextField in
            alertTextField.placeholder = "Enter Your ToDo"
            textField = alertTextField
        }
        let addItem = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text! != "" {
                
                let newItem = ToDoItem()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
            } else {
                let ac = UIAlertController(title: "Empty entry", message: "Please type something", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                ac.addAction(okAction)
                self.present(ac, animated: true)
            }
        }
        
        ac.addAction(addItem)
        present(ac, animated: true)
        
    }
    
}

