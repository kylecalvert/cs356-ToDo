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
    
    func getListName() -> String {
        getList()
        return TheList.curList?.name ?? "Unnamed List"
    }
    
    func renameList(name: String) {
        getList()
        TheList.curList!.name = name
    }
    
    func getCount() -> Int {
        return lists.count
    }
    
    func getTaskName() -> String {
        getTasks()
        return TheList.curTasks?[TasksViewController.selected!].name ?? "Unnamed Task"
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

