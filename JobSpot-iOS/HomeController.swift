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
import YNDropDownMenu

class HomeController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    let homeToProfile = "homeToProfile"
    let homeToLogin = "homeToLogin"
    let homeToList = "homeToList"
    let radius: CLLocationDistance = 15000
    //let locationLatLong = CLLocation(latitude: 28.1749353, longitude: -82.355302)
    var typedLocation = false
    @IBOutlet weak var mapViewOutlet: MKMapView!
    //@IBOutlet weak var searchBar: UISearchBar!
    var postalCodeLocation = " "
    //let apiController = ApiConfig()
    var cLLocationManager = CLLocationManager()
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locOutletLabel: UIButton!
    @IBOutlet weak var filterDropDown: UIView!
    @IBOutlet weak var savedSearchesOutlet: UIButton!
    @IBOutlet weak var filterButtonOutlet: UIButton!
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewOutlet.delegate = self
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.distanceFilter = 500
        //cLLocationManager.stopUpdatingLocation()
        //cLLocationManager.delegate = nil
        
        let YNDropDown = Bundle.main.loadNibNamed("YNDropDown", owner: nil, options: nil) as? [UIView]
        if let _YNDropDown = YNDropDown {
            let frame = CGRect(x: 0, y: 62, width: UIScreen.main.bounds.size.width, height: 32)
            let view = YNDropDownMenu(frame: frame, dropDownViews: _YNDropDown, dropDownViewTitles: ["Filter"])
            self.view.addSubview(view)
        }
        
    
    }
    
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToProfile, sender: nil)
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let jobTitleEntered = jobTitleTextField.text
        let locationEntered = locationTextField.text
        //let postalCodeLoc = String(describing: postalCodeLocation)
        
        if jobTitleEntered != "" && locationEntered != "" {
            getJobs(location: locationEntered!, jobTitle: jobTitleEntered!, radius: "60", sortColumns: "accquisitiondate", sortOrder: "desc", pageSize: "200", days: "60")
        } else {
            let emptyFields = UIAlertController(title: "Error", message: "Enter text into location and job title fields", preferredStyle: UIAlertControllerStyle.alert)
            emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(emptyFields, animated: true, completion: nil)
        }

    }
    
    @IBAction func savedSearchesAction(_ sender: UIButton) {
        debugPrint("savedSearchesAction")
    }
    
    
    @IBAction func currLocationAction(_ sender: UIButton) {
        debugPrint("currLocationAction")
        
        checkUserLocationStatus()
        
    }
    
    
    @IBAction func filterAction(_ sender: UIButton) {
        debugPrint("filterAction")
    }
    
    
    @IBAction func homePageAction(_ sender: UIButton) {
        debugPrint("homePageAction")
    }
    
    
    @IBAction func savedButtonAction(_ sender: UIButton) {
        debugPrint("savedButtonAction")
    }
    
    
    @IBAction func appliedJobsButtonAction(_ sender: UIButton) {
        debugPrint("appliedJobsButtonAction")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
                //debugPrint(user?.email! as Any)
            }
        }
        
    }
    
    
    func mapLocationSet(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  radius * 2.0, radius * 2.0)
        mapViewOutlet.setRegion(coordinates, animated: true)
    }
    
    
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            debugPrint("checkUserLocationStatus - authorizedWhenInUse")
            mapViewOutlet.showsUserLocation = true
            cLLocationManager.requestLocation()
        } else {
            debugPrint("checkUserLocationStatus - requestWhenInUseAuthorization")
            cLLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugPrint("viewDidAppear")
        
        checkUserLocationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    @IBAction func listActionButton(_ sender: UIButton) {
        //self.performSegue(withIdentifier: self.homeToList, sender: nil)
    }
    
    func getJobs(location: String, jobTitle: String, radius: String, sortColumns: String, sortOrder: String, pageSize: String, days: String) {
        //                                                                      user id         keyword         location        radius          sortColumns        sortOrder       startRecord   pageSize       days
        let urlRequestString = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/" + jobTitle + "/" + location + "/" + radius + "/" + sortColumns + "/" + sortOrder + "/" + "0" + "/" + pageSize + "/" + days + "/"
        debugPrint("urlRequestString: \(urlRequestString)")
        
        ///v1/jobsearch/{userId}/{keyword}/{location}/{radius}/{sortColumns}/{sortOrder}/{startRecord}/{pageSize}/{days}
        
        if let annotations = self.mapViewOutlet?.annotations {
            for _annotation in annotations {
                if let annotation = _annotation as? MKAnnotation
                {
                    self.mapViewOutlet.removeAnnotation(annotation)
                }
            }
        }
        
        let strGeoCodeLocInput = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
        
        debugPrint("GeoCodeString URL getJobs: \(strGeoCodeLocInput)")
        
        Alamofire.request(strGeoCodeLocInput, method: .post).responseJSON { response in
            
            debugPrint("Alamofire response 1: \(strGeoCodeLocInput)")
            
            let jsonResponseGeo = response.data
            let jsonGeo = JSON(data: jsonResponseGeo!)
            let jsonObjGeo = jsonGeo["results"].arrayValue
            for item in jsonObjGeo {
                let jsonGeometry = item["geometry"]
                
                let jsonLocation = jsonGeometry["location"]
                
                let jsonLatitude = jsonLocation["lat"].doubleValue
                let jsonLongitude = jsonLocation["lng"].doubleValue
                
                
                debugPrint("Location Lat: \(jsonLatitude)")
                debugPrint("Location Lng: \(jsonLongitude)")
                
                let locationLatLngInput = CLLocation(latitude: jsonLatitude, longitude: jsonLongitude)

                
                self.mapLocationSet(location: locationLatLngInput)
            }
            
        }
    

        
        Alamofire.request(urlRequestString, headers: headers).responseJSON { response in
            debugPrint("Alamofire response 2: \(response)")
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
                
                let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany + "+" + newLocation + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                
                debugPrint("GeoCodeString URL getJobs: \(geoCodeString)")
                
                Alamofire.request(geoCodeString, method: .post).responseJSON { response in
                    
                    let jsonResponseGeo = response.data
                    let jsonGeo = JSON(data: jsonResponseGeo!)
                    let jsonObjGeo = jsonGeo["results"].arrayValue
                    for item in jsonObjGeo {
                        let jsonGeometry = item["geometry"]
                        
                        let jsonLocation = jsonGeometry["location"]
                        
                        let jsonLatitude = jsonLocation["lat"].doubleValue
                        let jsonLongitude = jsonLocation["lng"].doubleValue
                        
                        
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
        debugPrint("locationManager: didChangeAuthorizationStatus")
        if status == .authorizedWhenInUse {
            cLLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("locationManager: didUpdateLocations")
        
        debugPrint(locations.first!)
        
        if let location = locations.first {
            
            let lat = location.coordinate.latitude as Double
            let lng = location.coordinate.longitude as Double
            
            let locationLatLong = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            mapLocationSet(location: locationLatLong)
            
            let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(lat) + "," + String(lng) + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
            
            debugPrint("GeoCodeString COORDs: \(geoCodeString)")
            
            Alamofire.request(geoCodeString, method: .post).responseJSON { response in
                
                debugPrint("response: \(response)")
                
                let jsonResponseGeo = response.data
                let jsonGeo = JSON(data: jsonResponseGeo!)
                
                let apiStatus = jsonGeo["status"].stringValue
                debugPrint("apiStatus: \(apiStatus)")
                
                if apiStatus == "OVER_QUERY_LIMIT" {
                    let emptyFields = UIAlertController(title: "API Limit Error", message: "The application has exceeded the API limit usage for Geocoding api. We are aware of the issue and please be patient.", preferredStyle: UIAlertControllerStyle.alert)
                    emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(emptyFields, animated: true, completion: nil)
                } else if apiStatus == "OK" {
                    let jsonObjGeo = jsonGeo["results"].arrayValue.first
                    let jsonGeometry = jsonObjGeo?["address_components"].arrayValue
                    
                    for components in jsonGeometry! {
                        debugPrint("components: \(components)")
                        
                        let addressType = components["types"].arrayValue
                        
                        for types in addressType {
                            debugPrint("addressTypes: \(types.stringValue)")
                            if types.stringValue == "postal_code" {
                                
                                self.postalCodeLocation = components["long_name"].stringValue
                                debugPrint("postalCode: \(self.postalCodeLocation)")
                                
                                if self.postalCodeLocation != " " {
                                    self.locationTextField.text = self.postalCodeLocation
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            
            
            
        }
    }
    
    @objc(locationManager:didFailWithError:)
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }

}


