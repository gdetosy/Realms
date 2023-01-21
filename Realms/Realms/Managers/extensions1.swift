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
    }
}
