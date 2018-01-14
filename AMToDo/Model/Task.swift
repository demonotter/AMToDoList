//
//  Task.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/10/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import Foundation
import RealmSwift

class Task : Object {
   @objc dynamic var id = 1
   @objc dynamic var title = ""
   @objc dynamic var isDone = false
   
   override static func primaryKey() -> String? {
      return "id"
   }
   
   convenience init(jsonData : [String : Any]) {
      self.init()
      self.id = jsonData["id"] as? Int ?? 0
      self.title = jsonData["title"] as? String ?? ""
      self.isDone = jsonData["completed"] as? Bool ?? false
   }

}
