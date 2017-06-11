//
//  AddListViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit
import CoreData

class AddListViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var colorPickerUIView: UIView!
    @IBOutlet weak var colorPicker: UIPickerView!
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
    
    //user pressed
    @IBAction func listColorButtonPressed(_ sender: UIButton) {
        //bring up a picker view with color choices
        colorPickerUIView.isHidden = false
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
        colorPicker.delegate = self
        newListTextField.delegate = self
        colorPickerUIView.isHidden = true
        
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(toggleDone), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        if !ListsViewController.isEditing {
            // set focus
            newListTextField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if ListsViewController.isEditing {
            // current list in text field
            newListTextField.text = TheList.shared.getListName()
            updateColorButtonTitle(toIndex: TheList.shared.getColorIndex())
            AddListViewController.selectedColor = TheList.shared.getColorIndex()
            // enable done with no changes
            newListDoneButton.isEnabled = true
        } else {
            AddListViewController.selectedColor = 0
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TheList.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AddListViewController.selectedColor = row
        updateColorButtonTitle(toIndex: AddListViewController.selectedColor)
        colorPickerUIView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TheList.colors[row].1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func updateColorButtonTitle(toIndex: Int) {
        listColorButton.setTitle(TheList.getColorName(at: toIndex), for: .normal)
    }
}
