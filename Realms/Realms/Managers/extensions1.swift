//
//  extensions1.swift
//  Realms
//
//  Created by tosy on 15.01.23.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        let notCompletedTasks = tasksList.task.filter("isComplete = false")
        let completedTasks = tasksList.task.filter("isComplete = true")

        textLabel?.text = tasksList.name

        if !notCompletedTasks.isEmpty {
            detailTextLabel?.text = "\(notCompletedTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .red
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            detailTextLabel?.textColor = .black
        }
    }
}

extension UIAlertController {
    
    static func showAlertWithTwoTF(tasksTVCFlow: TasksTVCFlow,
                                   okAction: (TasksTVCFlow) -> (),
                                   cancelAction: () -> ()) {
        
//        let txtAlertData = TxtAlertData(tasksTVCFlow: tasksTVCFlow)
//
//        let alert = UIAlertController(title: txtAlertData.titleForAlert,
//                                      message: txtAlertData.messageForAlert,
//                                      preferredStyle: .alert)
//
//        /// UITextField-s
//        var taskTextField: UITextField!
//        var noteTextField: UITextField!
//
//        alert.addTextField { textField in
//            taskTextField = textField
//            taskTextField.placeholder = txtAlertData.newTextFieldPlaceholder
//            taskTextField.text = txtAlertData.taskName
//        }
//
//        alert.addTextField { textField in
//            noteTextField = textField
//            noteTextField.placeholder = txtAlertData.noteTextFieldPlaceholder
//            noteTextField.text = txtAlertData.taskNote
//        }
//
//        /// Action-s
//
//        let saveAction = UIAlertAction(title: txtAlertData.doneButtonForAlert,
//                                       style: .default) { [weak self] _ in
//
//            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
//                  let newNote = noteTextField.text, !newNote.isEmpty,
//                  let self = self else { return }
//
//            switch tasksTVCFlow {
//                case .addingNewTask:
//                    let task = Task()
//                    task.name = newNameTask
//                    task.note = newNote
//                    guard let currentTasksList = self.currentTasksList else { return }
//                    StorageManager.saveTask(currentTasksList, task: task)
//                case .editingTask(let task):
//                    StorageManager.editTask(task,
//                                            newNameTask: newNameTask,
//                                            newNote: newNote)
//            }
//            self.filteringTasks()
//        }
//
//        let cancelAction = UIAlertAction(title: txtAlertData.cancelTxt, style: .destructive)
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
    }
}
