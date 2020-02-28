//
//  MasterViewController.swift
//  Lab4
//
//  Created by PT X02b on 2020-01-31.
//  Copyright © 2020 ics069. All rights reserved.
//

import UIKit
import os

class MasterViewController: UITableViewController {
    //CLASS VARIABLES
    var detailViewController: DetailViewController? = nil
    var objects = [PhotoEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (loadObjects() != nil) {
            objects = loadObjects()!
        }
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    //PURPOSE: inserts a new object to the top of the view once it has been created it will be saved and reloaded
    //PARAMETERS: sender -> object that initiated the insertion of a new object
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: exceptions are not caught
    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(PhotoEntry(photo: UIImage(named: "defaultImage")!, notes: "My Notes"), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        saveObjects()
        tableView.reloadData()
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if (detailViewController?.photoDidChange ?? false || detailViewController?.notesDidChange ?? false ) {
                    saveObjects()
                    tableView.reloadData()
                }
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.entry = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoEntryTableViewCell
        let object = objects[indexPath.row]
        cell.photoView.image = object.photo
        cell.notesView.text = object.notes
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            detailViewController?.photoView.image = nil
            detailViewController?.notesView.text = nil
            detailViewController?.camButton.isEnabled = false
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        saveObjects()
        tableView.reloadData()
    }
    
    //Mark: Load/Save
    //PURPOSE: Stores the object in the objects of type PhotoEntry variable after the Master view has been loaded and returns the object variable
    //PARAMETERS: [PhotoEntry]?: An optional array of PhotoEntry in the application
    //RETURN/SIDE EFFECTS: returns the objects variable which is in an array of type PhotoEntry if valid request
    //NOTES: Exceptions will be caught and logged, and result in the orderly termination of this function
    func loadObjects() -> [PhotoEntry]? {
        do {
            let data = try Data(contentsOf: PhotoEntry.archiveURL)
            //return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [PhotoEntry]
            if let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [PhotoEntry] {
                objects = loadedData
            }
            return objects
        } catch {
            os_log("Cannot load due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
            return nil
        }
    }
    
    //PURPOSE: Objects are saved and written to the objects variable of type PhotoEntry
    //PARAMETERS: N/A
    //RETURN/SIDE EFFECTS: N/A
    //NOTES: Exceptions will be caught and logged, and result in the orderly termination of this function
    func saveObjects() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: objects, requiringSecureCoding: false)
            try data.write(to: PhotoEntry.archiveURL)
        } catch {
            os_log("Cannot save due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
        }
    }

}

