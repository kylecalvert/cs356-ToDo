//
//  ListsViewController.swift
//  ToDo
//
//  Created by Kyle Calvert on 5/18/17.
//  Copyright © 2017 Kyle Calvert. All rights reserved.
//

import UIKit
import CoreData

class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // user-selected list row index
    static var selected : Int?
    // edit view check
    static var isEditing = false
    
    // set view context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // fetch lists
    func fetchLists() {
        do {
            TheList.shared.lists = try context.fetch(List.fetchRequest())
        } catch {
            print("Error: List fetch failed.")
        }
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBAction func addListButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addListSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //long-press gesture stuff
        let longPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TasksViewController.longPressed))
        self.listTableView.addGestureRecognizer(longPressedRecognizer)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListButton))]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLists()
        listTableView.reloadData()
        
        // reset isEditing
        ListsViewController.isEditing = false
    }
    
    //online
    func longPressed(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let locationTapped = recognizer.location(in: self.listTableView)
            if let tappedIndex = self.listTableView.indexPathForRow(at: locationTapped) {
                //go into edit for tapped index
                // set properties
                ListsViewController.selected = tappedIndex.row
                ListsViewController.isEditing = true
                
                // perform segue for editing
                performSegue(withIdentifier: "addListSegue", sender: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        do {
            count = try context.count(for: List.fetchRequest())
        } catch {
            print("Error: List fetch failed.")
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let list = TheList.shared.lists[indexPath.row]
        cell.textLabel?.text = list.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set selected list
        ListsViewController.selected = indexPath.row
        
        performSegue(withIdentifier: "tasksSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = TheList.shared.lists[indexPath.row]
            context.delete(list)
            
            // save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // reload
            fetchLists()
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

