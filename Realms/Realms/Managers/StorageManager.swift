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
