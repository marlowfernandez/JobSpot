//
//  DisplayStruct.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/7/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation

struct DisplayStruct {
    
    var jobTitle = String()
    var companyName = String()
    
    init(jobName: String, company: String) {
        
        self.jobTitle = jobName
        self.companyName = company
        
    }
}
