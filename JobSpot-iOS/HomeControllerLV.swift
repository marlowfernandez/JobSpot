//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import MapKit

class HomeControllerLV: UITableViewController {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    let homeToProfile = "listToProfile"
    let homeToLogin = "listToLogin"
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
    
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToProfile, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
                debugPrint(user?.email! as Any)
            }
        }
        
        getJobs()
        
    }
    
    var locationManager = CLLocationManager()
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapViewOutlet.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("viewDidAppear")
        checkUserLocationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear")
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
//        let structItem = items[indexPath.row]
//        
//        let structInt : Int = structItem.randNumber
//        let structIntToTString = String(structInt)
//        
//        cell.textLabel?.text = structItem.randText
//        cell.detailTextLabel?.text = structIntToTString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let structItem = items[indexPath.row]
//            structItem.ref?.removeValue()
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getJobs() {
        
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            let jsonObj = json["Jobs"]
            let jsonArrayVal = jsonObj.array
            
            debugPrint("COUNTER FOR ARRAY: \(String(describing: jsonArrayVal?.count))")
            
            for item in jsonArrayVal! {
                
                let jobID = item["JvId"].stringValue
                print("JobID: \(jobID)")
                
                let jobTitle = item["JobTitle"].stringValue
                print("JobTitle: \(jobTitle)")
                
                let company = item["Company"].stringValue
                print("Company: \(company)")
                
                let accquisitionDate = item["AccquisitionDate"].stringValue
                print("AccquisitionDate: \(accquisitionDate)")
                
                let url = item["URL"].stringValue
                print("URL: \(url)")
                
                let location = item["Location"].stringValue
                print("Location: \(location)")
                
                let fc = item["Fc"].stringValue
                print("Fc: \(fc)")
                
                let newCompany = company.replacingOccurrences(of: " ", with: "+")
                let newLocation = location.replacingOccurrences(of: " ", with: "+")
                
                let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany + newLocation + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                
                debugPrint("GeoCodeString URL: \(geoCodeString)")
                
                Alamofire.request(geoCodeString, method: .post).responseJSON { response in
                    
                    let jsonResponseGeo = response.data
                    let jsonGeo = JSON(data: jsonResponseGeo!)
                    let jsonObjGeo = jsonGeo["results"].arrayValue
                    for item in jsonObjGeo {
                        let jsonGeometry = item["geometry"]
                        
                        let jsonLocation = jsonGeometry["location"]
                        //debugPrint("jsonLocation: \(jsonLocation)")
                        
                        let jsonLatitude = jsonLocation["lat"].doubleValue
                        let jsonLongitude = jsonLocation["lng"].doubleValue
                        debugPrint("jsonLat: \(jsonLatitude)")
                        debugPrint("jsonLng: \(jsonLongitude)")
                    }
                    
                }
                
                print(" ")
            }
        }
    }

}



