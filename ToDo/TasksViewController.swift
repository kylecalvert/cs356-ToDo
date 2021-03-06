//
//  TasksViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    static let completedAlpha: CGFloat = 0.35
    // user-selected task row index
    static var selected : Int?
    // edit view check
    static var isEditing = false
    
    // set view context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // fetch tasks
    func fetchTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let list = TheList.shared.lists[ListsViewController.selected!]
        fetchRequest.predicate = NSPredicate(format: "list == %@", list)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isCompleted", ascending: true)]
        
        do {
            
            TheList.shared.tasks[list] = try context.fetch(fetchRequest) as? [Task]
        } catch {
            print("Error: Task fetch failed.")
        }
    }
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addTaskSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gesture stuff goes here
        let longPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TasksViewController.longPressed))
        self.tasksTableView.addGestureRecognizer(longPressedRecognizer)

        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButton))]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tasksTableView.backgroundColor = TheList.getColor(at: TheList.shared.getColorIndex())
        
        fetchTasks()
        tasksTableView.reloadData()
        
        // reset isEditing
        TasksViewController.isEditing = false
        // clear reminder date
        ReminderViewController.curReminder = nil
    }
    
    //online
    func longPressed(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            let locationTapped = recognizer.location(in: self.tasksTableView)
            if let tappedIndex = self.tasksTableView.indexPathForRow(at: locationTapped) {
                // set properties
                TasksViewController.selected = tappedIndex.row
                TasksViewController.isEditing = true
                
                // perform segue for editing
                performSegue(withIdentifier: "addTaskSegue", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TheList.shared.getCountTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let list = TheList.shared.lists[ListsViewController.selected!]
        let task = TheList.shared.tasks[list]?[indexPath.row]
        cell.contentView.backgroundColor = TheList.getColor(at: Int(list.colorIndex))
        
        cell.textLabel?.text = task?.name
        if (task?.isCompleted)! {
            cell.textLabel?.alpha = TasksViewController.completedAlpha
        } else {
            cell.textLabel?.alpha = 1.0
        }
        return cell
    }
    
    //little helper function for marking task complete
    func markCompleted(at index: Int) {
        let list = TheList.shared.lists[ListsViewController.selected!]
        let task = TheList.shared.tasks[list]?[index]
        
        // toggle isCompleted on selecting tasks
        if (task?.isCompleted)! {
            //undo whatever text modifications
            task?.isCompleted = false
        } else {
            //apply text modifications
            task?.isCompleted = true
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        fetchTasks()
        tasksTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        markCompleted(at: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = TheList.shared.lists[ListsViewController.selected!]
            let task = TheList.shared.tasks[list]?[indexPath.row]
            context.delete(task!)
            
            // save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // reload
            fetchTasks()
            tableView.reloadData()
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
