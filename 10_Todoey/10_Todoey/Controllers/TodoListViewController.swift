//
//  TodoListViewController.swift
//  10_Todoey
//
//  Created by Max Kraev on 05/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {
    
    var itemArray = [ToDoItem]()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.detailTextLabel?.text = itemArray[indexPath.row].subTitle
        
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
 
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return itemArray[indexPath.row].done
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(itemArray[indexPath.row])
            saveItems()
            itemArray.remove(at: indexPath.row)
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
        let addItem = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text! != "" {

                let newItem = ToDoItem(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
                
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
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()) {
       
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Cannot Fetch \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let descriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [descriptor]
        
        loadItems(with: fetchRequest)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

