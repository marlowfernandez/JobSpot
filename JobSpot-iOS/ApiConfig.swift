//
//  apiConfig.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 9/30/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ApiConfig {
    
    struct Jobs {
        let jobId : String
        let jobTitle : String
        let company : String
        let accquisitionDate : String
        let url : String
        let location : String
        
        
        init(dictionary: [String : String]) {
            self.jobId = dictionary["JvId"] ?? ""
            self.jobTitle = dictionary["JobTitle"] ?? ""
            self.company = dictionary["Company"] ?? ""
            self.accquisitionDate = dictionary["AccquisitionDate"] ?? ""
            self.url = dictionary["URL"] ?? ""
            self.location = dictionary["Location"] ?? ""
            
        }
    }
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    var jobsData = [Jobs]()
    
    func getJobs() {
        
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            //debugPrint("Alamofire response: \(response)")
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            let jsonObj = json["Jobs"]
            let jsonArrayVal = jsonObj.array
            
            for item in jsonArrayVal! {
                
                
                
                let jobTitle = item["JobTitle"].stringValue
                
                print(jobTitle)
                
                let company = item["Company"].stringValue
                print(company)
                
                let accquisitionDate = item["AccquisitionDate"].stringValue
                print(accquisitionDate)
                
                let url = item["URL"].stringValue
                print(url)
                
                let location = item["Location"].stringValue
                print(location)
                
                let fc = item["Fc"].stringValue
                print(fc)
                
                print(" ")
            }
        }
    }
    
}
