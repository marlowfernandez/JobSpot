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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        if savedSearchesItem.count > 0 {
//            return savedSearchesItem.count
//        } else {
//            return noItems.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellSavedJobs", for: indexPath)
        cell.selectionStyle = .none
        
//        if jobItems.count > 0 {
//            let jobData = jobItems[indexPath.row]
//            cell.textLabel?.text = jobData.companyName
//            cell.detailTextLabel?.text = jobData.jobTitle
//        } else {
//            let noData = noItems[indexPath.row]
//            cell.textLabel?.text = noData
//            cell.detailTextLabel?.text = " "
//        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //            let savedItem = savedSearchesItem[indexPath.row]
            //            savedItem.ref?.removeValue()
            //            self.tableViewOutlet.reloadData()
            print("ok")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
//        let savedJobItem = savedSearchesItem[(indexPath?.row)!]
//        
//        print("selected saved item: \(savedItem)")
//        
//        let alertController = UIAlertController(title: "Saved Searches", message: "Would you like to use this search again?", preferredStyle: .alert)
//        
//        alertController.addAction(UIAlertAction(title: "Search Again", style: .default, handler: {
//            alert -> Void in
//            
//            SaveSearch.days = savedItem.days2
//            SaveSearch.keywords = savedItem.keyword2
//            SaveSearch.location = savedItem.location2
//            SaveSearch.radius = savedItem.radius2
//            
//            print("SaveSearch days: \(SaveSearch.days)")
//            print("SaveSearch keywords: \(SaveSearch.keywords)")
//            print("SaveSearch location: \(SaveSearch.location)")
//            print("SaveSearch radius: \(SaveSearch.radius)")
//            
//            self.performSegue(withIdentifier: self.savedsearchesToHome, sender: nil)
//        }))
//        
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            alert -> Void in
//            
//        }))
//        
//        alertController.addTextField(configurationHandler: { (textField) -> Void in
//            textField.text = "Days: " + savedItem.days2
//            textField.textAlignment = .left
//            textField.isUserInteractionEnabled = false
//        })
//        
//        alertController.addTextField(configurationHandler: { (textField) -> Void in
//            textField.text = "Keyword: " + savedItem.keyword2
//            textField.textAlignment = .left
//            textField.isUserInteractionEnabled = false
//        })
//        
//        alertController.addTextField(configurationHandler: { (textField) -> Void in
//            textField.text = "Location: " + savedItem.location2
//            textField.textAlignment = .left
//            textField.isUserInteractionEnabled = false
//        })
//        
//        alertController.addTextField(configurationHandler: { (textField) -> Void in
//            textField.text = "Radius: " + savedItem.radius2
//            textField.textAlignment = .left
//            textField.isUserInteractionEnabled = false
//        })
//        
//        self.present(alertController, animated: true, completion: nil)
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
