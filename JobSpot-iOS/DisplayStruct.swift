//
//  DisplayStruct.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/7/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation

struct DisplayStruct {
    
    static var companyNameGlobal = String()
    static var datePostedGlobal = String()
    static var jobCityStateGlobal = String()
    static var jobIDGlobal = String()
    static var jobLatGlobal = String()
    static var jobLngGlobal = String()
    static var jobTitleGlobal = String()
    static var jobURLGlobal = String()
    
    var companyName = String()
    var datePosted = String()
    var jobCityState = String()
    var jobID = String()
    var jobLat = String()
    var jobLng = String()
    var jobTitle = String()
    var jobURL = String()
    
    init(company: String, datePosted: String, jobCityState: String, jobID: String, jobLat: String, jobLng: String, jobTitle: String, jobURL: String) {
        
        
        self.companyName = company
        self.datePosted = datePosted
        self.jobCityState = jobCityState
        self.jobID = jobID
        self.jobLat = jobLat
        self.jobLng = jobLng
        self.jobTitle = jobTitle
        self.jobURL = jobURL
        
    }
}
