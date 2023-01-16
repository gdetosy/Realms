//
//  StorageManager.swift
//  Realms
//
//  Created by tosy on 14.01.23.
//

import Foundation
import RealmSwift

let realm = try! Realm()
enum StorageManager {
    
    static func deleteList(_ tasksList: TasksList) {
        do {
            try realm.write {
                let tasks = tasksList.task

                realm.delete(tasks)
                realm.delete(tasksList)
            }
        } catch {
            print("deleteList error: \(error)")
        }
    }

    static func editTask(_ task: Task, newNameTask: String, newNote: String) {
        try! realm.write {
            task.name = newNameTask
            task.note = newNote
        }
    }

    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }

    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isCompleted.toggle()
        }
    }

    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.task.append(task)
        }
    }

    static func saveTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch {
            print("saveTasksList error: \(error)")
        }
    }

    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteall error: \(error)")
        }
    }

    static func getAllTasksList() -> Results<TasksList> {
        realm.objects(TasksList.self).sorted(byKeyPath: "name")
    }

    static func editList(_ tasksList: TasksList,
                         newListName: String,
                         complition: @escaping () -> Void)
    {
        do {
            try realm.write {
                tasksList.name = newListName
                complition()
            }
        } catch {
            print("editList error: \(error)")
        }
    }
}

enum TasksTVCFlow {
    case addingNewTask
    case editingTask(task: Task)
}

struct TxtAlertData {
    let titleForAlert = "Task value"
    var messageForAlert: String
    let doneButtonForAlert: String
    let cancelTxt = "Cancel"

    let newTextFieldPlaceholder = "New task"
    let noteTextFieldPlaceholder = "Note"

    var taskName: String?
    var taskNote: String?

    init(tasksTVCFlow: TasksTVCFlow) {
        switch tasksTVCFlow {
            case .addingNewTask:
                messageForAlert = "Please insert new task value"
                doneButtonForAlert = "Save"
            case .editingTask(let task):
                messageForAlert = "Please edit your task"
                doneButtonForAlert = "Update"
                taskName = task.name
                taskNote = task.note
        }
    }
}
