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
import Alamofire
import SwiftyJSON

class HomeController: UIViewController, MKMapViewDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    let homeToProfile = "homeToProfile"
    let homeToLogin = "homeToLogin"
    @IBOutlet weak var mapViewOutlet: MKMapView!
    let locationLatLong = CLLocation(latitude: 28.1749353, longitude: -82.355302)
    let urlCareerOneStop = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/programmer/orlando%2C%20fl/25/0/0/0/10/60"
    let apiController = ApiConfig()
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad")
        
        mapViewOutlet.delegate = self
        
        mapLocationSet(location: locationLatLong)
        
        
    
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
        
        getJobs()
        
    }
    
    let radius: CLLocationDistance = 5000
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
    
    func getJobs() {
        
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            //debugPrint("Alamofire response: \(response)")
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
                        
                        
                        let displayMarker = DisplayAnnotation(title: jobTitle,
                                                              locationName: company,
                                                              coordinate: CLLocationCoordinate2D(latitude: jsonLatitude, longitude: jsonLongitude))
                        
                        self.mapViewOutlet.addAnnotation(displayMarker)
                    }
                    
                }
                
                print(" ")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DisplayAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }

}



