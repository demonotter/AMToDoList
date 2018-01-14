//
//  ViewController.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/7/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   @IBOutlet weak var tasksTableView: UITableView!
   let viewModel = TasksViewModel()

   //MARK: View lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
      self.tasksTableView.tableFooterView = UIView(frame: CGRect.zero)
      self.setupViewModel()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.viewModel.getStoredTasks()
   }
   
   //MARK: View model
   func setupViewModel() {
      self.viewModel.getRemoteTasks()
      self.viewModel.updateClosure = {
         self.tasksTableView.reloadData()
      }
      self.viewModel.errorClosure = { error in
            //Handle error
      }
   }
   
   //MARK: Table view
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.viewModel.numberOfItems()
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")
      let task = self.viewModel.itemAtIndexPath(indexPath)!
      if task.isDone {
         let doneString = NSMutableAttributedString(string: task.title)
         doneString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, doneString.length))
         cell?.textLabel?.attributedText = doneString
      } else {
         cell?.textLabel?.text = task.title
      }
      return cell!
   }
   
   //MARK: Editing
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      
   }
   
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      let done = UITableViewRowAction(style : .default, title : "Done") { action, index in
         self.completeTask(indexPath: index)
      }
      done.backgroundColor = UIColor.lightGray
      let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
         self.deleteTask(indexPath: index)
      }
      if (self.viewModel.itemAtIndexPath(indexPath)?.isDone)! {
         return [delete]
      }
      return [delete, done]
   }
   
   //MARK: Actions
   @IBAction func addTaskButtonPressed(_ sender: Any) {
      if let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AddTaskViewController.self)) {
         (addTaskVC as! AddTaskViewController).viewModel = self.viewModel
         self.navigationController?.pushViewController(addTaskVC, animated: true)
      }
   }
   
   func completeTask(indexPath : IndexPath) {
      self.viewModel.complete(task : self.viewModel.itemAtIndexPath(indexPath)!)
   }
   
   func deleteTask(indexPath : IndexPath) {
      self.viewModel.delete(task : self.viewModel.itemAtIndexPath(indexPath)!)
   }
}

