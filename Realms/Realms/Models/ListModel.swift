//
//  ListModel.swift
//  Realms
//
//  Created by tosy on 14.01.23.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var data = Date()
    @Persisted var isCompleted = false
}
