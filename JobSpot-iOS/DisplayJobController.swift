//
//  DisplayJobController.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/8/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import LinkedinSwift
import Alamofire
import SwiftyJSON

class DisplayJobController: UIViewController {
    
    let displayToHome = "displayToHome"
    let displayToProfile = "displayToHome"
    let displayToSavedJobs = "displayToSavedJobs"
    let displayToAppliedJobs = "displayToAppliedJobs"
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var jobTitleOutlet: UILabel!
    @IBOutlet weak var jobCityStateOutlet: UILabel!
    @IBOutlet weak var datePostedOutlet: UILabel!
    var rootRef: FIRDatabaseReference!
    var companyName = " "
    var datePostedGlobal = " "
    var jobCityStateGlobal = " "
    var jobIDGlobal = " "
    var jobLatGlobal:Double = 0
    var jobLngGlobal:Double = 0
    var jobTitleGlobal = " "
    var jobURLGlobal = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameOutlet.text = DisplayStruct.companyNameGlobal
        jobTitleOutlet.text = DisplayStruct.jobTitleGlobal
        jobCityStateOutlet.text = DisplayStruct.jobCityStateGlobal
        datePostedOutlet.text = DisplayStruct.datePostedGlobal
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
    }

    @IBAction func saveJobAction(_ sender: UIButton) {
        
        
        let companyNameGlobal = DisplayStruct.companyNameGlobal
        debugPrint("companyName: \(companyName)")
        
        let datePostedGlobal = DisplayStruct.datePostedGlobal
        debugPrint("datePostedGlobal \(datePostedGlobal)")
        
        let jobCityStateGlobal = DisplayStruct.jobCityStateGlobal
        debugPrint("jobCityStateGlobal \(jobCityStateGlobal)")
        
        let jobIDGlobal = DisplayStruct.jobIDGlobal
        debugPrint("jobIDGlobal \(jobIDGlobal)")
        
        let jobLatGlobal = DisplayStruct.jobLatGlobal
        debugPrint("jobLatGlobal \(jobLatGlobal)")
        
        let jobLngGlobal = DisplayStruct.jobLngGlobal
        debugPrint("jobLngGlobal \(jobLngGlobal)")
        
        let jobTitleGlobal = DisplayStruct.jobTitleGlobal
        debugPrint("jobTitleGlobal \(jobTitleGlobal)")
        
        let jobURLGlobal = DisplayStruct.jobURLGlobal
        debugPrint("jobURLGlobal \(jobURLGlobal)")
        
        let applyDateGlobal = ""
        
        let saveJobItem = SaveJob(companyNameSave: companyNameGlobal, datePostedSave: datePostedGlobal, jobCityStateSave: jobCityStateGlobal, jobIDSave: jobIDGlobal, jobLatSave: jobLatGlobal, jobLngSave: jobLngGlobal, jobTitleSave: jobTitleGlobal, jobURLSave: jobURLGlobal, applyDateSave: applyDateGlobal)
        print("saveJobItem companyNAme: \(saveJobItem)")
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedjobs")
        
        print("listRef: \(listRef)")
        
        let addChildStr = listRef.child(jobIDGlobal)
        print("addChildStr: \(addChildStr)")
        
        addChildStr.setValue(saveJobItem.toAnyObject())
    }
    
    
    //NOT USED AT THE MOMENT
    private func saveJobToFireBase(companyName: String, datePosted: String, jobCityState: String, jobID: String, jobLat: Double, jobLng: Double, jobTitle: String, jobURL: String) {
        
        debugPrint("Save Job to FireBase \(companyName)")
        debugPrint("Save Job to FireBase \(datePosted)")
        debugPrint("Save Job to FireBase \(jobCityState)")
        debugPrint("Save Job to FireBase \(jobID)")
        debugPrint("Save Job to FireBase \(jobLat)")
        debugPrint("Save Job to FireBase \(jobLng)")
        debugPrint("Save Job to FireBase \(jobTitle)")
        debugPrint("Save Job to FireBase \(jobURL)")
        
//        let saveJobItem = SaveJob(companyNameSave: companyName, datePostedSave: datePosted, jobCityStateSave: jobCityState, jobIDSave: jobID, jobLatSave: jobLat, jobLngSave: jobLng, jobTitleSave: jobTitle, jobURLSave: jobURL, appleDateSave: " ")
//        print("saveJobItem: \(saveJobItem)")
        
        debugPrint(DisplayStruct.companyNameGlobal)
        debugPrint(DisplayStruct.datePostedGlobal)
        debugPrint(DisplayStruct.jobCityStateGlobal)
        debugPrint(DisplayStruct.jobIDGlobal)
        debugPrint(DisplayStruct.jobLatGlobal)
        debugPrint(DisplayStruct.jobLngGlobal)
        debugPrint(DisplayStruct.jobTitleGlobal)
        debugPrint(DisplayStruct.jobURLGlobal)
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedjobs")
        
        print("listRef: \(listRef)")
    }
    
    @IBAction func goToHomeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToHome, sender: nil)
    }
    
    @IBAction func goToProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToProfile, sender: nil)
    }
    
    @IBAction func savedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToSavedJobs, sender: nil)
    }
    
    @IBAction func appliedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToAppliedJobs, sender: nil)
    }
    
}
