//
//  AddListViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit
import CoreData

class AddListViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var newListTextField: UITextField!
    @IBOutlet weak var newListDoneButton: UIButton!
    
    @IBAction func newListDoneButton(_ sender: UIButton) {
        //TheList.shared.addList(newListTextField.text!)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let list = List(context: context)
        list.name = newListTextField.text!
        
        // save
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // TODO: check text field and toggle Done button
        
        // return to previous view
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func toggleDone() {
        let text = newListTextField.text
        if !text!.isEmpty {
            newListDoneButton.isEnabled = true
        } else {
            newListDoneButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDone), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        newListTextField.delegate = self
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
