//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var taskInputField: UITextField!
    @IBOutlet weak var taskDoneButton: UIButton!
    
    func toggleDone() {
        let text = taskInputField.text
        if !text!.isEmpty {
            taskDoneButton.isEnabled = true
        } else {
            taskDoneButton.isEnabled = false
        }
    }
    
    @IBAction func addTaskDoneButton(_ sender: UIButton) {
        let list = TheList.shared.lists[ListsViewController.selected!]
        
        // check text field and toggle Done button
        if TasksViewController.isEditing {
            // edit current task
            TheList.shared.renameTask(to: taskInputField.text!)
        } else {
            // create a new task
            let task = Task(context: context)
            task.name = taskInputField.text!
            task.list = list
        }
        
        // save
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // return to previous view
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskInputField.delegate = self
        
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDone), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        if !TasksViewController.isEditing {
            // set focus
            taskInputField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if TasksViewController.isEditing {
            // current task in text field
            taskInputField.text = TheList.shared.getTaskName()
            // enable done with no changes
            taskDoneButton.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // call parent
        super.viewWillDisappear(animated)
        
        // turn off receiving all notifications
        NotificationCenter.default.removeObserver(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
