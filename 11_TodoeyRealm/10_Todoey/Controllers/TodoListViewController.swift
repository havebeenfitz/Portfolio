//
//  TodoListViewController.swift
//  10_Todoey
//
//  Created by Max Kraev on 05/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController  {
    
    let realm = try! Realm()
    var toDoItems: Results<ToDoItem>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        title = selectedCategory?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let category = selectedCategory {
            guard let navBar = navigationController?.navigationBar else { fatalError("No navigation controller") }
            navBar.barTintColor = UIColor(hexString: category.color)
            navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: category.color), isFlat: true)
            
            if #available(iOS 11.0, *) {
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: category.color), isFlat: true)]
            } else {
                // Fallback on earlier versions
                navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: category.color), isFlat: true)]
            }
            searchBar.barTintColor = UIColor(hexString: category.color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("No navigation controller") }
        navBar.barTintColor = UIColor.flatWhite()
        
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.flatBlackColorDark()]
        } else {
            // Fallback on earlier versions
            navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.flatBlackColorDark()]
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = toDoItems?[indexPath.row].title
            cell.detailTextLabel?.text = toDoItems?[indexPath.row].subTitle
            cell.accessoryType = item.done ? .checkmark : .none
            
            let gradientPercentage = CGFloat(CGFloat(indexPath.row) / CGFloat((toDoItems!.count)))
            
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: gradientPercentage)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
            cell.detailTextLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
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
    
    // MARK: - Swipe Cell Delegate Methods
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        return super.tableView(tableView, editActionsForRowAt: indexPath, for: .right)
        
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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(addItem)
        ac.addAction(cancel)
        
        present(ac, animated: true)

    }
    // MARK: - Save & Load Items Core Data
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Items
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
                
            } catch {
                print("error deleting Item \(error)")
            }
        }
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
