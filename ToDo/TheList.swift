//
//  TheList.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit
import CoreData

class TheList {
    static let shared = TheList()
    static var curList: List?
    static var curTasks: [Task]?
        
    var lists: [List] = []
    var tasks: [List : [Task]] = [:]
    
    // list functions
    func addList(_ name : String) {
        let newList = List()
        newList.name = name
        lists.append(newList)
    }
    
    func removeList() {
        getList()
        tasks.removeValue(forKey: TheList.curList!)
        lists.remove(at: ListsViewController.selected!)
    }
    
    func renameList(name: String) {
        getList()
        TheList.curList!.name = name
    }
    
    func getCount() -> Int {
        return lists.count
    }
    
    // task functions
    func addTask(_ name: String, to list: List) {
        getTasks()
        let newTask = Task()
        newTask.name = name
        TheList.curTasks!.append(newTask)
    }
    
    func removeTask() {
        getTasks()
        TheList.curTasks?.remove(at: TasksViewController.selected!)
    }
    
    func getTaskName() -> String {
        getTasks()
        return TheList.curTasks?[TasksViewController.selected!].name ?? ""
    }
    
    func renameTask(to name: String) {
        getTasks()
        let task = TheList.curTasks![TasksViewController.selected!]
        task.name = name
    }
    
    func getCountTasks() -> Int {
        getTasks()
        return TheList.curTasks!.count
    }
    
    
    // helper functions to set current list and tasks array
    private func getList() {
        TheList.curList = lists[ListsViewController.selected!]
    }
    
    private func getTasks() {
        getList()
        TheList.curTasks = tasks[TheList.curList!]!
    }
    
}

