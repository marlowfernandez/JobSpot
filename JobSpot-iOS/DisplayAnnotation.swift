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
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
