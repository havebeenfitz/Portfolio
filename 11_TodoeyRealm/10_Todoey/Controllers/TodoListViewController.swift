//
//  TodoListViewController.swift
//  10_Todoey
//
//  Created by Max Kraev on 05/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController  {
    
    let realm = try! Realm()
    
    
    var toDoItems: Results<ToDoItem>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = toDoItems?[indexPath.row].title
            cell.detailTextLabel?.text = toDoItems?[indexPath.row].subTitle
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving checkmark \(error)")
            }
        
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return toDoItems?[indexPath.row].done ?? false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = toDoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                    
                } catch {
                    print("error deleting Item \(error)")
                }
            }
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    // MARK: - Add Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let ac = UIAlertController(title: "Add new ToDo", message: nil, preferredStyle: .alert)

        ac.addTextField { alertTextField in
            alertTextField.placeholder = "Enter Your ToDo"
            textField = alertTextField
        }
        let addItem = UIAlertAction(title: "Add", style: .default) { _ in

            if textField.text! != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = ToDoItem()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd.MM.yyyy"
                            
                            newItem.title = textField.text!
                            newItem.subTitle = formatter.string(from: Date())
                            
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving items, \(error)")
                    }
                }
 
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
    // MARK: - Save & Load Items Core Data
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }

}

