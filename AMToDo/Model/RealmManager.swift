//
//  RealmManager.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/10/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import Foundation
import RealmSwift

let currentSchemaVersion : UInt64 = 1
class RealmManager {
   //MARK: Initialization
   static let instance = RealmManager()
   let realm = try! Realm()
   init() {
      self.migrateIfNecessary()
   }
   
   //MARK: Tasks
   private func lastTaskID() -> Int {
      return realm.objects(Task.self).last?.id ?? 0
   }
   
   func allTasks() -> [Task]? {
      return Array(realm.objects(Task.self))
   }
   
   func add(task : Task) {
      try! realm.write {
         task.id = lastTaskID() + 1
         realm.add(task, update: true)
      }
   }
   
   func complete(task : Task) {
      try! realm.write {
         task.isDone = true
      }
   }
   
   func delete(task : Task) {
      try! realm.write {
         realm.delete(task)
      }
   }
   
   //MARK: Migration
   func migrateIfNecessary () {
      let config = Realm.Configuration(
         schemaVersion: currentSchemaVersion,
         migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < currentSchemaVersion {
               //Perform migration
            }
      })
      Realm.Configuration.defaultConfiguration = config
   }
}
