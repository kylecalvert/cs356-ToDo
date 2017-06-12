//
//  ColorViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 6/11/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    static var color: Int?
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBAction func doneColorButton(_ sender: UIButton) {
        if let color = ColorViewController.color {
            AddListViewController.selectedColor = color
        }
        
        // return to previous view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelColorButton(_ sender: UIButton) {
        // return to previous view
        ColorViewController.color = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPickerView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // PickerView functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TheList.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ColorViewController.color = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TheList.colors[row].1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
