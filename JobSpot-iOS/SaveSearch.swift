//
//  SaveSearch.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/7/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase

struct SaveSearch {
    
    static var keywords : String = String()
    static var radius = String()
    static var location = String()
    static var days = String()
    static var dateTime = String()
    
    init(keywords: String, radius: String, location: String, days: String, dateTime: String) {
        
        SaveSearch.keywords = keywords
        SaveSearch.radius = radius
        SaveSearch.location = location
        SaveSearch.days = days
        SaveSearch.dateTime = dateTime
        
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "dateTime": SaveSearch.dateTime,
            "days": SaveSearch.days,
            "keywords": SaveSearch.keywords,
            "location": SaveSearch.location,
            "radius": SaveSearch.radius
        ]
    }
    
}
