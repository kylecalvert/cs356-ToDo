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
    
    var lists: [List] = []
    var tasks: [List : [Task]] = [:]
    
    // List functions
    
    func getList() -> List {
        return lists[ListsViewController.selected!]
    }
    
    func getListName() -> String {
        return getList().name ?? "Unnamed List"
    }
    
    func renameList(name: String) {
        getList().name = name
    }
    
    func getCount() -> Int {
        return lists.count
    }
    
    // Task functions
    
    func getTasks() -> [Task] {
        return tasks[getList()]!
    }
    
    func getTaskName() -> String {
        return getTasks()[TasksViewController.selected!].name ?? "Unnamed Task"
    }
    
    func setReminder(to date: Date) {
        getTasks()[TasksViewController.selected!].reminder = date as NSDate
    }
    
    func getReminder() -> String {
        //return getTasks()[TasksViewController.selected!].reminder? ?? "None"
        if let reminder = getTasks()[TasksViewController.selected!].reminder {
            return DateFormatter.localizedString(from: reminder as Date, dateStyle: .short, timeStyle: .short)
        } else {
            return "None"
        }
    }
    
    // force unwraps, check before calling
    func getReminderDate() -> Date {
        return getTasks()[TasksViewController.selected!].reminder! as Date
    }
    
    func isReminderSet() -> Bool {
        return getTasks()[TasksViewController.selected!].reminder != nil
    }
    
    func renameTask(to name: String) {
        getTasks()[TasksViewController.selected!].name = name
    }
    
    func getCountTasks() -> Int {
        return getTasks().count
    }
    
    //color stuff
    static let colors = [(UIColor(red: 175/255, green: 172/255, blue: 159/255, alpha: 1.0), "Slate"),
                      (UIColor(red: 226/255, green: 233/255, blue: 16/255, alpha: 1.0), "Sunbeam"),
                      (UIColor(red: 172/255, green: 145/255, blue: 176/255, alpha: 1.0), "Mauve"),
					  (UIColor(red: 122/255, green: 208/255, blue: 95/255, alpha: 1.0), "Grass"),
					  (UIColor(red: 224/255, green: 159/255, blue: 15/255, alpha: 1.0), "Carrot"),
					  (UIColor(red: 111/255, green: 175/255, blue: 199/255, alpha: 1.0), "Robin Egg")]
    
    func getColor(at index: Int) -> UIColor {
        return TheList.colors[index].0
    }
    
    func getColorName(at index: Int) -> String {
        return TheList.colors[index].1
    }
    
    func changeColor(to cIndex: Int) {
        getList().colorIndex = Int32(cIndex)
    }
    
    func getColorIndex() -> Int {
        return Int(getList().colorIndex)
    }
}
