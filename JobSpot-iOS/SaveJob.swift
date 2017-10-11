//
//  SaveJob.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/10/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase

struct SaveJob {
    
    var companyNameGlobal = String()
    var datePostedGlobal = String()
    var jobCityStateGlobal = String()
    var jobIDGlobal = String()
    var jobLatGlobal = Double()
    var jobLngGlobal = Double()
    var jobTitleGlobal = String()
    var jobURLGlobal = String()
    
    var companyName = String()
    var datePosted = String()
    var jobCityState = String()
    var jobID = String()
    var jobLat = Double()
    var jobLng = Double()
    var jobTitle = String()
    var jobURL = String()
    
    var ref: FIRDatabaseReference?
    
    init(companyNameSave: String, datePostedSave: String, jobCityStateSave: String, jobIDSave: String, jobLatSave: Double, jobLngSave: Double, jobTitleSave: String, jobURLSave: String) {
        
        companyNameGlobal = companyNameSave
        datePostedGlobal = datePostedSave
        jobCityStateGlobal = jobCityStateSave
        jobIDGlobal = jobIDSave
        jobLatGlobal = jobLatSave
        jobLngGlobal = jobLngSave
        jobTitleGlobal = jobTitleSave
        jobURLGlobal = jobURLSave
        
    }
    
    init(companyName: String, datePosted: String, jobCityState: String, jobID: String, jobLat: Double, jobLng: Double, jobTitle: String, jobURL: String, refVal: FIRDatabaseReference) {
        self.companyName = companyName
        self.datePosted = datePosted
        self.jobCityState = jobCityState
        self.jobID = jobID
        self.jobLat = jobLat
        self.jobLng = jobLng
        self.jobTitle = jobTitle
        self.jobURL = jobURL
        self.ref = refVal
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        companyName = snapshotValue["companyName"] as! String
        print("companyName: \(companyName)")
        
        datePosted = snapshotValue["datePosted"] as! String
        print("datePosted: \(datePosted)")
        
        jobCityState = snapshotValue["jobCityState"] as! String
        print("jobCityState: \(jobCityState)")
        
        jobID = snapshotValue["jobID"] as! String
        print("jobID: \(jobID)")
        
        jobLat = snapshotValue["jobLat"] as! Double
        print("jobLat: \(jobLat)")
        
        jobLng = snapshotValue["jobLng"] as! Double
        print("jobLng: \(jobLng)")
        
        jobTitle = snapshotValue["jobTitle"] as! String
        print("jobTitle: \(jobTitle)")
        
        jobURL = snapshotValue["jobURL"] as! String
        print("jobURL: \(jobURL)")
        
        ref = snapshot.ref
        print("ref: \(String(describing: ref))")
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "companyName": companyNameGlobal,
            "datePosted": datePostedGlobal,
            "jobCityState": jobCityStateGlobal,
            "jobID": jobIDGlobal,
            "jobLat": jobLatGlobal,
            "jobLng": jobLngGlobal,
            "jobTitle": jobTitleGlobal,
            "jobURL": jobURLGlobal
        ]
    }
    
}
