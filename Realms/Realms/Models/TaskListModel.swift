//
//  TaskListModel.swift
//  Realms
//
//  Created by tosy on 14.01.23.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @Persisted var name = ""
    @Persisted var data = Date()
    @Persisted var task = List<Task>()
}
