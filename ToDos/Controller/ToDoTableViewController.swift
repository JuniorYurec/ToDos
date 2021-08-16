//
//  ToDoTableViewController.swift
//  ToDos
//
//  Created by Iurii Chernovalov on 17.06.21.
//

import UIKit
import CoreData
import SwipeCellKit

class ToDoTableViewController: SwipeTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    var categories = [Category]()
    
    var currentCategory: Category? {
        
        didSet {
            
            loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadItems()
        
        self.navigationItem.title = "ToDos"
        
    }
    
    //MARK: - Add new Item (ToDo)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.name = textField.text!
            
            newItem.dateCreated = Date()
            
            newItem.done = false
            
            newItem.parentCategory = self.currentCategory
            
            self.items.append(newItem)
            
            self.saveItem()
            
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new ToDo"
            
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].name
        
        if items[indexPath.row].done == true {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        tableView.reloadData()
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItem() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Error saving context: \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", currentCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
        do {
            
            try items = context.fetch(request)
            
        } catch {
            
            print("Error fetching data from context \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    override func editModel(at indexPath: IndexPath) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit current ToDo", message: "", preferredStyle: .alert)
        
        let item = items[indexPath.row]
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if  textField.text != "" {
                
                item.name = textField.text!
                
            }
            
            self.saveItem()
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Edit current ToDo"
            
            alertTextField.text = item.name
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        let item = self.items[indexPath.row]
        
        let alertCategoryDeleted = UIAlertController(title: "Item '\(item.name ?? "nill")' was deleted", message: "", preferredStyle: .actionSheet)
        
        self.context.delete(items[indexPath.row])
        
        items.remove(at: indexPath.row)
        
        present(alertCategoryDeleted, animated: true) {
            
            usleep(500000)
            
            alertCategoryDeleted.dismiss(animated: true, completion: nil)
            
        }
    }
}

//MARK: - Search bar methods

extension ToDoTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
        } else {
            
            searchBarSearchButtonClicked(searchBar)
            
        }
    }
}

