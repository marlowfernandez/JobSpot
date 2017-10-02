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

class HomeController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    let homeToProfile = "homeToProfile"
    let homeToLogin = "homeToLogin"
    let homeToList = "homeToList"
    let radius: CLLocationDistance = 5000
    let locationLatLong = CLLocation(latitude: 28.1749353, longitude: -82.355302)
    @IBOutlet weak var mapViewOutlet: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    //let apiController = ApiConfig()
    var cLLocationManager = CLLocationManager()
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewOutlet.delegate = self
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.requestWhenInUseAuthorization()
        cLLocationManager.requestLocation()
        
        mapLocationSet(location: locationLatLong)
    
    }
    
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToProfile, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
                //debugPrint(user?.email! as Any)
            }
        }
        
        getJobs()
        
    }
    
    
    func mapLocationSet(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  radius * 2.0, radius * 2.0)
        mapViewOutlet.setRegion(coordinates, animated: true)
    }
    
    
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapViewOutlet.showsUserLocation = true
        } else {
            cLLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserLocationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    @IBAction func listActionButton(_ sender: UIButton) {
        //self.performSegue(withIdentifier: self.homeToList, sender: nil)
    }
    
    func getJobs() {
        
        Alamofire.request("https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/manager/wesley%20chapel%20fl/25/accquisitiondate/desc/0/200/30/", headers: headers).responseJSON { response in
            //debugPrint("Alamofire response: \(response)")
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            let jsonObj = json["Jobs"]
            let jsonArrayVal = jsonObj.array
            
            //debugPrint("COUNTER FOR ARRAY: \(String(describing: jsonArrayVal?.count))")
            
            for item in jsonArrayVal! {
                
                let jobID = item["JvId"].stringValue
                //print("JobID: \(jobID)")
                
                let jobTitle = item["JobTitle"].stringValue
                //print("JobTitle: \(jobTitle)")
                
                let company = item["Company"].stringValue
                //print("Company: \(company)")
                
                let accquisitionDate = item["AccquisitionDate"].stringValue
                //print("AccquisitionDate: \(accquisitionDate)")
                
                let url = item["URL"].stringValue
                //print("URL: \(url)")
                
                let location = item["Location"].stringValue
                //print("Location: \(location)")
                
                let fc = item["Fc"].stringValue
                //print("Fc: \(fc)")
                
                let newCompany = company.replacingOccurrences(of: " ", with: "+")
                let newLocation = location.replacingOccurrences(of: " ", with: "+")
                
                let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany + newLocation + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                
                //debugPrint("GeoCodeString URL: \(geoCodeString)")
                
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
                        //debugPrint("jsonLat: \(jsonLatitude)")
                        //debugPrint("jsonLng: \(jsonLongitude)")
                        
                        
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
        if let annotate = annotation as? DisplayAnnotation {
            let identifier = "pin"
            var vewMKPinAnnoytation: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotate
                vewMKPinAnnoytation = dequeuedView
            } else {
                vewMKPinAnnoytation = MKPinAnnotationView(annotation: annotate, reuseIdentifier: identifier)
                vewMKPinAnnoytation.canShowCallout = true
                vewMKPinAnnoytation.calloutOffset = CGPoint(x: -5, y: 5)
                vewMKPinAnnoytation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return vewMKPinAnnoytation
        }
        return nil
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            cLLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location lat:  \(location.coordinate.latitude)")
            print("location lng:  \(location.coordinate.longitude)")
            
            let lat = location.coordinate.latitude as Double
            let lng = location.coordinate.longitude as Double
            
            let locationLatLong = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            //mapLocationSet(location: locationLatLong)
            
            let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(lat) + "," + String(lng) + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
            
            debugPrint("GeoCodeString COORDs: \(geoCodeString)")
            
            Alamofire.request(geoCodeString, method: .post).responseJSON { response in
                
                let jsonResponseGeo = response.data
                let jsonGeo = JSON(data: jsonResponseGeo!)
                let jsonObjGeo = jsonGeo["results"].arrayValue
                for item in jsonObjGeo {
                    let jsonGeometry = item["address_components"]
                    debugPrint("jsonGeometry: \(jsonGeometry)")
                    
                    let jsonLocation = jsonGeometry["location"]
                    
                    
                    //let jsonLatitude = jsonLocation["lat"].doubleValue
                    //let jsonLongitude = jsonLocation["lng"].doubleValue
                    //debugPrint("jsonLat: \(jsonLatitude)")
                    //debugPrint("jsonLng: \(jsonLongitude)")
                }
                
            }
        }
    }
    
    @objc(locationManager:didFailWithError:)
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }

}


