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
    
    var keyword2 = String()
    var radius2 = String()
    var location2 = String()
    var days2 = String()
    var dateTime2 = String()
    
    init(keywords: String, radius: String, location: String, days: String, dateTime: String) {
        
        SaveSearch.keywords = keywords
        SaveSearch.radius = radius
        SaveSearch.location = location
        SaveSearch.days = days
        SaveSearch.dateTime = dateTime
        
    }
    
    init(keywords2: String, radius2: String, location2: String, days2: String, dateTime2: String) {
        self.keyword2 = keywords2
        self.radius2 = radius2
        self.location2 = location2
        self.days2 = days2
        self.dateTime2 = dateTime2
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateTime2 = snapshotValue["dateTime"] as! String
        print("dateTime2: \(dateTime2)")
        days2 = snapshotValue["days"] as! String
        print("days2: \(days2)")
        keyword2 = snapshotValue["keywords"] as! String
        print("keyword2: \(keyword2)")
        location2 = snapshotValue["location"] as! String
        print("location2: \(location2)")
        radius2 = snapshotValue["radius"] as! String
        print("radius2: \(radius2)")
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
