//
//  AddTaskViewController.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/11/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import UIKit
import Foundation

class AddTaskViewController: UIViewController, UITextFieldDelegate {
   @IBOutlet weak var titleTextField: UITextField!
   var viewModel : TasksViewModel?
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      self.titleTextField.becomeFirstResponder()
   }
   
   //MARK: Text field delegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      self.viewModel?.addTask(title: self.titleTextField.text!)
      self.navigationController?.popViewController(animated: true)
      return true
   }
}

