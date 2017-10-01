//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController, MKMapViewDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    let homeToProfile = "homeToProfile"
    let homeToLogin = "homeToLogin"
    @IBOutlet weak var mapViewOutlet: MKMapView!
    let locationLatLong = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let urlCareerOneStop = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/programmer/orlando%2C%20fl/25/0/0/0/10/60"
    let apiController = ApiConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad")
        
        mapLocationSet(location: locationLatLong)
        
        
        //https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/programmer/orlando%2C%20fl/25/0/0/0/10/60
        
        
//        let url = NSURL(string: urlCareerOneStop)!
//        
//        let config = URLSessionConfiguration.default
//        
//        config.httpAdditionalHeaders = [
//            "Accept": "application/json",
//            "user_key": "imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ=="
//        ]
//        
//        let urlSession = URLSession(configuration: config)
//        
//        let myQuery = urlSession.dataTask(with: url as URL, completionHandler: {
//            data, response, error -> Void in
//            /* ... */
//            
//            if error != nil {
//                debugPrint(error!)
//            } else {
//                do {
//                    
//                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
//                    debugPrint(parsedData)
//                } catch let error as NSError {
//                    print(error)
//                }
//            }
//            
//            
//        })
//        myQuery.resume()
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToProfile, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear")
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
                debugPrint(user?.email! as Any)
            }
        }
        
        apiController.getJobs()
        
    }
    
    let radius: CLLocationDistance = 1000
    func mapLocationSet(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  radius * 2.0, radius * 2.0)
        mapViewOutlet.setRegion(coordinates, animated: true)
    }
    
    var locationManager = CLLocationManager()
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapViewOutlet.showsUserLocation = true
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
}

