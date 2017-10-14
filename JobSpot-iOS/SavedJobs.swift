//
//  SavedJobs.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/11/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SavedJobs: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let savedjobsToHome = "savedjobsToHome"
    let savedjobsToProfile = "savedjobsToProfile"
    let savedjobsToApplied = "savedjobsToAppliedJobs"
    let savedjobsToDisplay = "savedjobsToDisplay"
    var savedjobsItems : [SaveJob] = []
    var noItems = ["No saved jobs to display"]
    var rootRef: FIRDatabaseReference!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        //print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        //print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedjobs")
        
        debugPrint("listRef: \(listRef)")
        
        listRef.observe(.value, with: { snapshot in
            self.savedjobsItems.removeAll()
            for item in snapshot.children {
                let structItem = SaveJob(snapshot: item as! FIRDataSnapshot)
                print("structItem: \(structItem)")
                self.savedjobsItems.append(structItem)
            }
            self.tableViewOutlet.reloadData()
            print("savedjobsItems List: \(self.savedjobsItems)")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedjobsItems.count > 0 {
            return savedjobsItems.count
        } else {
            return noItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellSavedJobs", for: indexPath)
        cell.selectionStyle = .none
        
        if savedjobsItems.count > 0 {
            let jobData = savedjobsItems[indexPath.row]
            cell.textLabel?.text = jobData.jobTitleGlobal
            cell.detailTextLabel?.text = jobData.companyNameGlobal
        } else {
            let noData = noItems[indexPath.row]
            cell.textLabel?.text = noData
            cell.detailTextLabel?.text = " "
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let savedItem = savedjobsItems[indexPath.row]
            savedItem.ref?.removeValue()
            self.tableViewOutlet.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if savedjobsItems.count > 0 {
            let savedJobItem = savedjobsItems[(indexPath?.row)!]
            
            print("selected saved item: \(savedJobItem)")
            
            let alertController = UIAlertController(title: "Saved Jobs", message: "Would you like to view this job?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "View Job", style: .default, handler: {
                alert -> Void in
                
                DisplayStruct.companyNameGlobal = savedJobItem.companyNameGlobal
                DisplayStruct.datePostedGlobal = savedJobItem.datePostedGlobal
                DisplayStruct.jobCityStateGlobal = savedJobItem.jobCityStateGlobal
                DisplayStruct.jobIDGlobal = savedJobItem.jobIDGlobal
                DisplayStruct.jobLatGlobal = savedJobItem.jobLatGlobal
                DisplayStruct.jobLngGlobal = savedJobItem.jobLngGlobal
                DisplayStruct.jobTitleGlobal = savedJobItem.jobTitleGlobal
                DisplayStruct.jobURLGlobal = savedJobItem.jobURLGlobal
                
                print("SavedJobs companyNameGlobal: \(DisplayStruct.companyNameGlobal)")
                print("SavedJobs datePostedGlobal: \(DisplayStruct.datePostedGlobal)")
                print("SavedJobs jobCityStateGlobal: \(DisplayStruct.jobCityStateGlobal)")
                print("SavedJobs jobIDGlobal: \(DisplayStruct.jobIDGlobal)")
                print("SavedJobs jobLatGlobal: \(DisplayStruct.jobLatGlobal)")
                print("SavedJobs jobLngGlobal: \(DisplayStruct.jobLngGlobal)")
                print("SavedJobs jobTitleGlobal: \(DisplayStruct.jobTitleGlobal)")
                print("SavedJobs jobURLGlobal: \(DisplayStruct.jobURLGlobal)")
                
                self.performSegue(withIdentifier: self.savedjobsToDisplay, sender: nil)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                alert -> Void in
                
            }))
            
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "Company Name: " + savedJobItem.companyNameGlobal
                textField.textAlignment = .left
                textField.isUserInteractionEnabled = false
            })
            
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "Title: " + savedJobItem.jobTitleGlobal
                textField.textAlignment = .left
                textField.isUserInteractionEnabled = false
            })
            
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "Location: " + savedJobItem.jobCityStateGlobal
                textField.textAlignment = .left
                textField.isUserInteractionEnabled = false
            })
            
            alertController.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "Date Posted: " + savedJobItem.datePostedGlobal
                textField.textAlignment = .left
                textField.isUserInteractionEnabled = false
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func homeActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedjobsToHome, sender: nil)
    }
    
    @IBAction func savedActionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func appliedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedjobsToApplied, sender: nil)
    }
    
    @IBAction func profileActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.savedjobsToProfile, sender: nil)
    }
    
}
