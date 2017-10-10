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
    let companyName: String
    let coordinate: CLLocationCoordinate2D
    let cityState: String
    let datePosted: String
    let lat: Double
    let lng: Double
    let url: String
    
    init(title: String, companyName: String, coordinate: CLLocationCoordinate2D, cityState: String, datePosted: String,
         lat: Double, lng: Double, url: String) {
        self.title = title
        self.companyName = companyName
        self.coordinate = coordinate
        self.cityState = cityState
        self.datePosted = datePosted
        self.lat = lat
        self.lng = lng
        self.url = url
        
        super.init()
    }
    
    var subtitle: String? {
        return companyName
    }
}
