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
    
    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var newListTextField: UITextField!
    @IBOutlet weak var newListDoneButton: UIButton!
    @IBOutlet weak var listColorButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var selectedColor = 0
    
    @IBAction func newListDoneButton(_ sender: UIButton) {
        if ListsViewController.isEditing {
            //edit current list
            TheList.shared.renameList(name: newListTextField.text!)
            TheList.shared.changeColor(to: AddListViewController.selectedColor)
        } else {
            let list = List(context: context)
            list.name = newListTextField.text!
            list.colorIndex = Int32(AddListViewController.selectedColor)
        }
        
        // save
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
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
    
    func updateColorButtonTitle(toIndex: Int) {
        listColorButton.setTitle(TheList.getColorName(at: toIndex), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newListTextField.delegate = self
        
        
        
        if !ListsViewController.isEditing {
            // set focus
            newListTextField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDone), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

        if ListsViewController.isEditing {
            listStatusLabel.text = "Editing ToDo List"
            // current list in text field
            newListTextField.text = TheList.shared.getListName()
            // check if user set color
            if let color = ColorViewController.color {
                AddListViewController.selectedColor = color
            } else {
                AddListViewController.selectedColor = TheList.shared.getColorIndex()
            }
            // enable done with no changes
            newListDoneButton.isEnabled = true
        } else {
            listStatusLabel.text = "New ToDo List"
            if let color = ColorViewController.color {
                AddListViewController.selectedColor = color
            } else {
                AddListViewController.selectedColor = 0
            }
        }
        
        listColorButton.setTitle(TheList.getColorName(at: AddListViewController.selectedColor), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // call parent
        super.viewWillDisappear(animated)
        
        // reset color
        ColorViewController.color = nil
        
        // turn off receiving all notifications
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
