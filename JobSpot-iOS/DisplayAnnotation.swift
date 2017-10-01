//
//  DisplayAnnotation.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/1/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import MapKit

class DisplayAnnotation: NSObject, MKAnnotation {
    let titleNew: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(titleNew: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.titleNew = titleNew
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitleNew: String {
        return locationName
    }
}
