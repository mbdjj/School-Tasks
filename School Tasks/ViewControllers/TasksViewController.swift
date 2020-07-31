//
//  ViewController.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 29/07/2020.
//  Copyright © 2020 Marcin Bartminski. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    
    var tasksArray = [Task]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tasksArray.count == 0 {
            return 1
        } else {
            return tasksArray.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tasksArray.count == 0 {
            let noTaskCell = tableView.dequeueReusableCell(withIdentifier: "noTaskCell")
            return noTaskCell!
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasksArray = try context.fetch(request)
        } catch {
            print("Error fetching data form context: \(error)")
        }
    }

    
}

