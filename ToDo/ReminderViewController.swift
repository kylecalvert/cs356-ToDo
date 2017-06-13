//
//  ReminderViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 6/7/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    
    static var curReminder: Date?

    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    
    @IBAction func reminderDone(_ sender: UIButton) {
        ReminderViewController.curReminder = reminderDatePicker.date
        
        // return to previous view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reminderCancel(_ sender: Any) {
        // return to previous view
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if TasksViewController.isEditing && TheList.shared.isReminderSet() {
            // set DatePicker to current task reminder
            ReminderViewController.curReminder = TheList.shared.getReminderDate()
            reminderDatePicker.date = ReminderViewController.curReminder!
        } else {
            ReminderViewController.curReminder = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
