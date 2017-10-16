//
//  SavedSearches.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/7/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Alamofire
import SwiftyJSON

class SavedSearchesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var savedSearchesItem: [SaveSearch] = []
    var noItems = ["No items to display"]
    var rootRef: FIRDatabaseReference!
    
    let savedsearchesToHome = "savedsearchesToHome"
    let savedsearchesToProfile = "savedsearchesToProfile"
    let savedsearchesToSavedJobs = "savedsearchesToSavedJobs"
    let savedsearchesToAppliedJobs = "savedsearchesToAppliedJobs"
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedsearches")
        
        debugPrint("listRef: \(listRef)")
        
        listRef.observe(.value, with: { snapshot in
            self.savedSearchesItem.removeAll()
            for item in snapshot.children {
                let structItem = SaveSearch(snapshot: item as! FIRDataSnapshot)
                print("structItem: \(structItem)")
                self.savedSearchesItem.append(structItem)
            }
            //self.items = newItems
            self.tableViewOutlet.reloadData()
            print("savedSearchedItem List: \(self.savedSearchesItem)")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedSearchesItem.count > 0 {
            return savedSearchesItem.count
        } else {
            return noItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellSavedSearch", for: indexPath)
        cell.selectionStyle = .none
        
        if savedSearchesItem.count > 0 {
            let searchedData = savedSearchesItem[indexPath.row]
            cell.textLabel?.text = searchedData.keyword2
            cell.detailTextLabel?.text = searchedData.location2
        } else {
            let noData = noItems[indexPath.row]
            cell.textLabel?.text = noData
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this search?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                let savedItem = self.savedSearchesItem[indexPath.row]
                savedItem.ref?.removeValue()
                self.tableViewOutlet.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let savedItem = savedSearchesItem[(indexPath?.row)!]
        
        print("selected saved item: \(savedItem)")
        
        let alertController = UIAlertController(title: "Saved Searches", message: "Would you like to use this search again?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Search Again", style: .default, handler: {
            alert -> Void in
            
            SaveSearch.days = savedItem.days2
            SaveSearch.keywords = savedItem.keyword2
            SaveSearch.location = savedItem.location2
            SaveSearch.radius = savedItem.radius2
            
            print("SaveSearch days: \(SaveSearch.days)")
            print("SaveSearch keywords: \(SaveSearch.keywords)")
            print("SaveSearch location: \(SaveSearch.location)")
            print("SaveSearch radius: \(SaveSearch.radius)")
            
            self.performSegue(withIdentifier: self.savedsearchesToHome, sender: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            alert -> Void in
            
            let savedItem = self.savedSearchesItem[(indexPath?.row)!]
            savedItem.ref?.removeValue()
            self.tableViewOutlet.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            alert -> Void in
            
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "Days: " + savedItem.days2
            textField.textAlignment = .left
            textField.isUserInteractionEnabled = false
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "Keyword: " + savedItem.keyword2
            textField.textAlignment = .left
            textField.isUserInteractionEnabled = false
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "Location: " + savedItem.location2
            textField.textAlignment = .left
            textField.isUserInteractionEnabled = false
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "Radius: " + savedItem.radius2
            textField.textAlignment = .left
            textField.isUserInteractionEnabled = false
        })
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved Searches"
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToProfile, sender: nil)
    }
    
    @IBAction func appliedAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToAppliedJobs, sender: nil)
        
    }
    
    @IBAction func savedAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToSavedJobs, sender: nil)
        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedsearchesToHome, sender: nil)
    }
    
}
