//
//  APIClient.swift
//  AMToDo
//
//  Created by Dmitry Zheshinsky on 1/11/18.
//  Copyright © 2018 Dmitry Zheshinsky. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift


let baseURL = "https://jsonplaceholder.typicode.com/todos/"

enum APIError : Error {
   case noData
   case requestFailed
}
class APIClient {
   func getAllTasks() -> SignalProducer<[Task], APIError> {
      return SignalProducer { producer, disposable -> () in
         Alamofire.request(baseURL).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
               producer.send(error: APIError.requestFailed)
               return
            }
            guard let responseArray = response.result.value as? [[String : Any]] else {
               producer.send(error: APIError.noData)
               return
            }
            let tasks = responseArray.flatMap({ dict in
               return Task(jsonData: dict)
            })
            producer.send(value: tasks)
         }
      }
   }
   
   func createTask(_ task : Task) -> SignalProducer<Bool ,APIError> {
      return SignalProducer { producer, disposable -> () in
         let parameters: [String: Any] = ["id" : task.id, "title": task.title]
         Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
               producer.send(error: APIError.requestFailed)
               return
            }
            producer.send(value: response.result.isSuccess)
         }
      }
   }
   
   func completeTask(_ task : Task) -> SignalProducer<Bool ,APIError> {
      return SignalProducer { producer, disposable -> () in
         let parameters: [String: Any] = ["id" : task.id]
         Alamofire.request(baseURL, method: .put, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
               producer.send(error: APIError.requestFailed)
               return
            }
            producer.send(value: response.result.isSuccess)
         }
      }
   }
   
   func deleteTaskWithID(_ taskID : Int) -> SignalProducer<Bool ,APIError> {
      return SignalProducer { producer, disposable -> () in
         let parameters: [String: Any] = ["id" : taskID]
         Alamofire.request(baseURL, method: .delete, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
               producer.send(error: APIError.requestFailed)
               return
            }
            producer.send(value: response.result.isSuccess)
         }
      }
   }
}
