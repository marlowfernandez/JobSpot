//
//  ProfileStruct.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/8/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation

struct ProfileStruct {
    
    static var fullNameProf = String()
    static var headlineProf = String()
    static var locationProf = String()
    static var summaryProf = String()
    static var pictureProf = String()
    static var emailProf = String()
    
    var fullName = String()
    var headline = String()
    var location = String()
    var summary = String()
    var picture = String()
    var email = String()
    
    init(fullName: String, headline: String, location: String, summary: String, picture: String, email: String) {
        self.fullName = fullName
        self.headline = headline
        self.location = location
        self.summary = summary
        self.picture = picture
        self.email = email
    }
    
    init(fullNameProf: String, headlineProf: String, locationProf: String, summaryProf: String, pictureProf: String, emailProf: String) {
        
        ProfileStruct.fullNameProf = fullNameProf
        ProfileStruct.headlineProf = headlineProf
        ProfileStruct.locationProf = locationProf
        ProfileStruct.summaryProf = summaryProf
        ProfileStruct.pictureProf = pictureProf
        ProfileStruct.emailProf = emailProf
        
    }
}
