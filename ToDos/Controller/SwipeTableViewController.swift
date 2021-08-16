//
//  SwipeTableViewController.swift
//  ToDos
//
//  Created by Iurii Chernovalov on 13.06.21.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
   //MARK: -  Swipe Datasource Merhods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
        }
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            
            self.editModel(at: indexPath)
        }
        // TODO: future feature
//        let moveAction = SwipeAction(style: .destructive, title: "move") { action, indexPath in
//            self.moveObject(at: indexPath)
//        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        
        editAction.image = UIImage(named: "square.and.pencil")
        
        // TODO: future feature
//moveAction.image = UIImage(named: "arrowshape.turn.up.left.circle")
// moveAction.backgroundColor = UIColor.lightGray
        editAction.backgroundColor = UIColor.blue
       
        

        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {

    }
    
    func editModel(at indexPath: IndexPath) {

    }
//    func moveObject(at indexPath: IndexPath) {
//
//    }

}
