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

class ApiConfig {
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    func getJobs() {
        
        //Version 4
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            debugPrint("Alamofire response: \(response)")
        }
    }
    
}
