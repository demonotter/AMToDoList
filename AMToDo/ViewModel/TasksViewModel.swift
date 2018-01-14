//
//  TasksViewModel.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/12/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import Foundation

class TasksViewModel {
   let apiClient = APIClient()
   private var tasks : [Task]?
   var updateClosure : (() -> ())?
   var errorClosure : ((_ error : Error) -> ())?
   
   //MARK: Data source
   func numberOfItems() -> Int {
      return self.tasks?.count ?? 0
   }
   
   func itemAtIndexPath(_ indexPath : IndexPath) -> Task? {
      return self.tasks?[indexPath.row]
   }
   
   //MARK: Tasks loading
   func getStoredTasks() {
      self.tasks = RealmManager.instance.allTasks()?.reversed().sorted(by: { (task1, task2) -> Bool in
         return task2.isDone && !task1.isDone
      })
      self.updateClosure?()
   }
   
   func getRemoteTasks() {
      apiClient.getAllTasks().startWithResult { result in
         if let error = result.error {
            self.errorClosure?(error)
         } else {
            self.tasks = result.value
            self.saveRemoteTasks(result.value!)
            self.updateClosure?()
         }
      }
   }
   
   func saveRemoteTasks(_ tasks : [Task]) {
      tasks.forEach { task in
         RealmManager.instance.add(task: task)
      }
   }
   
   //MARK: Tasks operations
   func addTask(title : String) {
      if title != "" {
         let task = Task()
         task.title = title
         RealmManager.instance.add(task: task)
         self.updateClosure?()
      }
   }
   
   func complete(task : Task) {
      RealmManager.instance.complete(task: task)
      self.getStoredTasks()
      apiClient.completeTask(task).startWithResult { result in
         if let error = result.error {
            self.errorClosure?(error)
         }
      }
   }
   
   func delete(task : Task) {
      let taskID = task.id
      RealmManager.instance.delete(task: task)
      self.getStoredTasks()
      apiClient.deleteTaskWithID(taskID).startWithResult { result in
         if let error = result.error {
            self.errorClosure?(error)
         }
      }
   }
}
