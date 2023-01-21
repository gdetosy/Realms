//
//  TasksTableViewController.swift
//  Realms
//
//  Created by tosy on 15.01.23.
//

import RealmSwift
import UIKit


final class TasksTableViewController: UITableViewController {
    var currentTasksList: TasksList?
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList?.name
      
        filteringTasks()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not completed tasks" : "Completed tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(tasksTVCFlow: .editingTask(task: task))
        }
        
        let doneText = task.isCompleted ? "Not done" : "Done"
        let doneContextItem = UIContextualAction(style: .destructive, title: doneText) { _, _, _ in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        
        return swipeActions
    }
    
    private func filteringTasks() {
        notCompletedTasks = currentTasksList?.task.filter("isCompleted = false")
        completedTasks = currentTasksList?.task.filter("isCompleted = true")
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension TasksTableViewController {
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdateList(tasksTVCFlow: .addingNewTask)
    }
    
    private func alertForAddAndUpdateList(tasksTVCFlow: TasksTVCFlow) {
        let txtAlertData = TxtAlertData(tasksTVCFlow: tasksTVCFlow)
  
        let alert = UIAlertController(title: txtAlertData.titleForAlert,
                                      message: txtAlertData.messageForAlert,
                                      preferredStyle: .alert)
 
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = txtAlertData.newTextFieldPlaceholder
            taskTextField.text = txtAlertData.taskName
        }

        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = txtAlertData.noteTextFieldPlaceholder
            noteTextField.text = txtAlertData.taskNote
        }

        let saveAction = UIAlertAction(title: txtAlertData.doneButtonForAlert,
                                       style: .default) { [weak self] _ in

            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
                  let newNote = noteTextField.text, !newNote.isEmpty,
                  let self = self else { return }

            switch tasksTVCFlow {
                case .addingNewTask:
                    let task = Task()
                    task.name = newNameTask
                    task.note = newNote
                    guard let currentTasksList = self.currentTasksList else { return }
                    StorageManager.saveTask(currentTasksList, task: task)
                case .editingTask(let task):
                    StorageManager.editTask(task,
                                            newNameTask: newNameTask,
                                            newNote: newNote)
            }
            self.filteringTasks()
        }

        let cancelAction = UIAlertAction(title: txtAlertData.cancelTxt, style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
