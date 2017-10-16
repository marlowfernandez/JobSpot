//
//  AppliedJobs.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/11/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds

class AppliedJobs: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appliedToHome = "appliedToHome"
    let appliedToProfile = "appliedToProfile"
    let appliedToSavedJobs = "appliedToSavedJobs"
    let appliedToDisplay = "appliedToDisplay"
    var noItems = ["No items to display"]
    var appliedJobsItem : [SaveJob] = []
    var rootRef: FIRDatabaseReference!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bannerViewOutlet: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.dismissKeyboardTapped()
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,   // All simulators
            "e15b0e554146870aff4b7ef47282e61c" ];  // Sample device ID
        
        //bannerViewOutlet.adUnitID = "ca-app-pub-3940256099942544/6300978111" //test banner id
        bannerViewOutlet.adUnitID = "ca-app-pub-6204503397505906/2185014830" //real banner id
        bannerViewOutlet.rootViewController = self
        bannerViewOutlet.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        //print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        //print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        //print("ifRef: \(idRef)")
        
        let listRef = idRef.child("appliedjobs")
        
        debugPrint("listRef: \(listRef)")
        
        listRef.observe(.value, with: { snapshot in
            self.appliedJobsItem.removeAll()
            for item in snapshot.children {
                let structItem = SaveJob(snapshot: item as! FIRDataSnapshot)
                print("structItem: \(structItem)")
                self.appliedJobsItem.append(structItem)
            }
            self.tableViewOutlet.reloadData()
            print("savedjobsItems List: \(self.appliedJobsItem)")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appliedJobsItem.count > 0 {
            return appliedJobsItem.count
        } else {
            return noItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellAppliedJobs", for: indexPath)
        cell.selectionStyle = .none
        
        if appliedJobsItem.count > 0 {
            let jobData = appliedJobsItem[indexPath.row]
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
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this as an applied job of yours?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                let savedItem = self.appliedJobsItem[indexPath.row]
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
        
        if appliedJobsItem.count > 0 {
            let savedJobItem = appliedJobsItem[(indexPath?.row)!]
            
            print("selected saved item: \(savedJobItem)")
            
            let alertController = UIAlertController(title: "Applied Jobs", message: "Would you like to view this job?", preferredStyle: .alert)
            
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
                
                self.performSegue(withIdentifier: self.appliedToDisplay, sender: nil)
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
    
}
