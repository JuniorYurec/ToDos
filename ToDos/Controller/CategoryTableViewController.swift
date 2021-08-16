//
//  CategoryTableViewController.swift
//  ToDos
//
//  Created by Iurii Chernovalov on 13.06.21.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: SwipeTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
        self.navigationItem.title = "ToDos"
        
    }
    //MARK: - Add new Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategory()
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Category"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.currentCategory = categories[indexPath.row]
            
        }
    }
    
    //MARK: - Model Manipulation Methods
    func saveCategory() {
        
        do {

            try context.save()
            
        } catch {
            
            print("Error saving context: \(error)")
            
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            try categories = context.fetch(request)
            
        } catch {
            
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    override func editModel(at indexPath: IndexPath) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit current Category", message: "", preferredStyle: .alert)
        
        let category = categories[indexPath.row]
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if  textField.text != "" {
                
                category.name = textField.text!
                
            }
            self.saveCategory()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Edit current Category"
            
            alertTextField.text = category.name
            
            textField = alertTextField
            
        }
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        let category = self.categories[indexPath.row]
        
        let alertCategoryDeleted = UIAlertController(title: "Category '\(category.name ?? "nill")' was deleted", message: "", preferredStyle: .actionSheet)
        
        self.context.delete(categories[indexPath.row])
        
        self.saveCategory()
        
        categories.remove(at: indexPath.row)
        
        present(alertCategoryDeleted, animated: true) {
            
            usleep(500000)
            alertCategoryDeleted.dismiss(animated: true, completion: nil)
            
        }
        
    }
}

//MARK: - Search bar methods

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategories(with: request)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadCategories()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        } else {
            
            searchBarSearchButtonClicked(searchBar)
            
        }
    }
}
