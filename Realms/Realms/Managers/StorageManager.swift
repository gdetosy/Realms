//
//  StorageManager.swift
//  Realms
//
//  Created by tosy on 14.01.23.
//

import Foundation
import RealmSwift

let realm = try! Realm()
class StorageManager {

    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteall error: \(error)")
        }
    }
    static func getAllTasksList()-> Results<TasksList> {
        realm.objects(TasksList.self).sorted(byKeyPath: "name")
    }
}
 
