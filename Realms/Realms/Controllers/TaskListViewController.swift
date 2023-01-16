//
//  TaskListViewController.swift
//  Realms
//
//  Created by tosy on 14.01.23.
//

import UIKit
import RealmSwift

final class TaskListViewController: UITableViewController {
    var tasksLists: Results<TasksList>!
    override func viewDidLoad() {
        super.viewDidLoad()
        StorageManager.deleteAll()
        tasksLists = StorageManager.getAllTasksList()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemSelector))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }
    
    @IBAction func SegmentedControl(_ sender: UISegmentedControl) {
        let byKeyPath = sender.selectedSegmentIndex == 0 ? "name" : "data"
        tasksLists = tasksLists.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = tasksLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = taskList.task.count.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksLists[indexPath.row]

        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let editeContextItem = UIContextualAction(style: .destructive, title: "Edite") { _, _, _ in
            self.alertForTask(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        let doneContextItem = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
        }

        editeContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green

        let swipeAtions = UISwipeActionsConfiguration(actions: [deleteContextItem, editeContextItem, doneContextItem])

        return swipeAtions
    }
   
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TasksTableViewController,
           let index = tableView.indexPathForSelectedRow
        {
            let tasksList = tasksLists[index.row]
            destinationVC.currentTasksList = tasksList
        }
    }
  
    @objc func addBarButtonItemSelector() {
        alertForTask {
            [weak self] in print("new list add")
            self?.tableView.reloadData()
        }
    }

    private func alertForTask(_ tasksList: TasksList? = nil, complition: @escaping () -> Void) {
        let tittle = tasksList == nil ? "New List" : "Edit List"
        let message = "Please insert list name"
        let doneButton = tasksList == nil ? "Save" : "Update"
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newListName = alertTextField.text, !newListName.isEmpty else { return }
            
            if let tasksList = tasksList {
                StorageManager.editList(tasksList, newListName: newListName, complition: complition)
            } else {
                let tasksList = TasksList()
                tasksList.name = newListName
                StorageManager.saveTasksList(tasksList: tasksList)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField {
            textField in
            alertTextField = textField
            if let listName = tasksList {
                alertTextField.text = listName.name
            }
            alertTextField.placeholder = "List Name"
        }
        present(alert, animated: true)
    }
}
    
