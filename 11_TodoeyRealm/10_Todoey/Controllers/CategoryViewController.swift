//
//  CategoryViewController.swift
//  10_Todoey
//
//  Created by Max Kraev on 06/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(categoryArray[indexPath.row])
            saveCategories()
            
            categoryArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Saving and Loading from Core Data
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
    }
    
    func loadCategories(for request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Cannot Fetch categories \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    
    @IBAction func addCategoryPressd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Your Category"
            textField = alertTextField
        }
        let addCategory = UIAlertAction(title: "Add", style: .default) { (addAction) in
            
            if textField.text != "" {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategories()
                self.tableView.reloadData()
            } else {
                let ac = UIAlertController(title: "Empty entry", message: "Please type something", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                ac.addAction(okAction)
                self.present(ac, animated: true)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(addCategory)
        ac.addAction(cancel)
        
        present(ac, animated: true)
        
    }
    
    
    
}
