//
//  ProfileStruct.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/8/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase

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
    
    var fullNameSave = String()
    var headlineSave = String()
    var locationSave = String()
    var summarySave = String()
    var pictureSave = String()
    var emailSave = String()
    
    var ref: FIRDatabaseReference?
    
    init(fullName: String, headline: String, location: String, summary: String, picture: String, email: String, ref: FIRDatabaseReference? = nil) {
        self.fullName = fullName
        self.headline = headline
        self.location = location
        self.summary = summary
        self.picture = picture
        self.email = email
        self.ref = ref
    }
    
    init(fullNameProf: String, headlineProf: String, locationProf: String, summaryProf: String, pictureProf: String, emailProf: String) {
        
        ProfileStruct.fullNameProf = fullNameProf
        ProfileStruct.headlineProf = headlineProf
        ProfileStruct.locationProf = locationProf
        ProfileStruct.summaryProf = summaryProf
        ProfileStruct.pictureProf = pictureProf
        ProfileStruct.emailProf = emailProf
        
    }
    
    init(fullNameNew: String, headlineNew: String, locationNew: String, summaryNew: String, pictureNew: String, emailNew: String) {
        fullNameSave = fullNameNew
        headlineSave = headlineNew
        locationSave = locationNew
        summarySave = summaryNew
        pictureSave = pictureNew
        emailSave = emailNew
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        debugPrint("snapshot: \(snapshot)")
        
        debugPrint("snapshot value: \(snapshot.value!)")
        
        let snapshotValue = snapshot.value as! [String: Any?]
        
        debugPrint("snapshotValue: \(snapshotValue)")

        if snapshotValue["email"] != nil {
            emailSave = snapshotValue["email"]! as! String
            print("email: \(emailSave)")
        }

        if snapshotValue["fullName"] != nil {
            fullNameSave = snapshotValue["fullName"] as! String
            print("fullName: \(fullNameSave)")
        }
        
        if snapshotValue["location"] != nil {
            locationSave = snapshotValue["location"] as! String
            print("location: \(locationSave)")
        }
        
        if snapshotValue["summary"] != nil {
            summarySave = snapshotValue["summary"] as! String
            print("summary: \(summarySave)")
        }
        
        if snapshotValue["headline"] != nil {
            headlineSave = snapshotValue["headline"] as! String
            print("headline: \(headlineSave)")
        }
        
        if snapshotValue["picture"] != nil {
            pictureSave = snapshotValue["picture"] as! String
            print("picture: \(pictureSave)")
        }
        
        ref = snapshot.ref
        print("ref: \(String(describing: ref))")
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "email": emailSave,
            "fullName": fullNameSave,
            "location": locationSave,
            "summary": summarySave,
            "headline": headlineSave,
            "picture": pictureSave
        ]
    }
}
