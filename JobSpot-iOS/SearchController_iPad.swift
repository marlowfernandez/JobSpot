//
//  SearchController_iPad.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/18/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Alamofire
import SwiftyJSON
import YNDropDownMenu
import GoogleMobileAds

class SearchController_iPad: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //segues
    let homeToLogin = "homeToLogin"
    let homeToDisplay = "homeToDisplay"
    
    //Global
    var handle: FIRAuthStateDidChangeListenerHandle?
    var rootRef: FIRDatabaseReference!
    let radius: CLLocationDistance = 15000
    var typedLocation = false
    var postalCodeLocation = " "
    var cLLocationManager = CLLocationManager()
    var passUserLocationBool : Bool = true
    var jobItems: [DisplayStruct] = []
    var searchSaveItems: [SaveSearch] = []
    var noItems = ["No jobs to display"]
    var lat : Double = 0
    var lng : Double = 0
    
    //Header for authentication
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    //Outlets
    @IBOutlet weak var myLocationOutlet: UIButton!
    @IBOutlet weak var goSearchOutlet: UIButton!
    @IBOutlet weak var searchHistoryOutlet: UIButton!
    @IBOutlet weak var homeSearchOutlet: UIButton!
    @IBOutlet weak var savedJobsOutlet: UIButton!
    @IBOutlet weak var appliedJobsOutlet: UIButton!
    @IBOutlet weak var profileScreenOutlet: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationInputTextField: UITextField!
    @IBOutlet weak var keywordInputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.dismissKeyboardTapped()
        
        mapView.delegate = self
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.distanceFilter = 500
        
        YNFilterView.FilterValues.radiusString = "20"
        YNFilterView.FilterValues.daysEntered = "30"
        YNFilterView.FilterValues.jobSort = "accquisitiondate"
        
//        print("SaveSearch days from HOME: \(SaveSearch.days)")
//        print("SaveSearch keywords from HOME: \(SaveSearch.keywords)")
//        print("SaveSearch location from HOME: \(SaveSearch.location)")
//        print("SaveSearch radius from HOME: \(SaveSearch.radius)")
        
        if !(SaveSearch.location.isEmpty || SaveSearch.location == "") {
            passUserLocationBool = false
            locationInputTextField.text = SaveSearch.location
        }
        
        if !(SaveSearch.keywords.isEmpty || SaveSearch.keywords == "") {
            locationInputTextField.text = SaveSearch.keywords
        }
        
        if !(SaveSearch.days.isEmpty || SaveSearch.days == "") {
            YNFilterView.FilterValues.daysEntered = SaveSearch.days
//            print("YNFilterView from SaveSearch days: \(YNFilterView.FilterValues.daysEntered)")
        }
        
        if !(SaveSearch.radius.isEmpty || SaveSearch.radius == "") {
            YNFilterView.FilterValues.radiusString = SaveSearch.radius
//            print("YNFilterView from SaveSearch radius: \(YNFilterView.FilterValues.radiusString)")
        }
        
        let YNDropDown = Bundle.main.loadNibNamed("YNDropDown", owner: nil, options: nil) as? [UIView]
        if let _YNDropDown = YNDropDown {
            let frame = CGRect(x: 0, y: 62, width: UIScreen.main.bounds.size.width, height: 32)
            let view = YNDropDownMenu(frame: frame, dropDownViews: _YNDropDown, dropDownViewTitles: ["Filter"])
            self.view.addSubview(view)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
            }
        }
        
        rootRef = FIRDatabase.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserLocationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    @IBAction func goSearchAction(_ sender: UIButton) {
        let jobTitleEntered = keywordInputTextField.text
        let locationEntered = locationInputTextField.text
        
        if jobTitleEntered != "" && locationEntered != "" {
            getJobs(location: locationEntered!, jobTitle: jobTitleEntered!, radius: YNFilterView.FilterValues.radiusString, sortColumns: YNFilterView.FilterValues.jobSort, sortOrder: "desc", pageSize: "200", days: YNFilterView.FilterValues.daysEntered)
        } else {
            let emptyFields = UIAlertController(title: "Error", message: "Enter text into location and job title fields", preferredStyle: UIAlertControllerStyle.alert)
            emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(emptyFields, animated: true, completion: nil)
        }

    }
    
    @IBAction func myLocationAction(_ sender: UIButton) {
        passUserLocationBool = true
        checkUserLocationStatus()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if jobItems.count > 0 {
            return jobItems.count
        } else {
            return noItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if jobItems.count > 0 {
            let jobItem = jobItems[(indexPath?.row)!]
            
            DisplayStruct.companyNameGlobal = jobItem.companyName
            DisplayStruct.datePostedGlobal = jobItem.datePosted
            DisplayStruct.jobCityStateGlobal = jobItem.jobCityState
            DisplayStruct.jobIDGlobal = jobItem.jobID
            DisplayStruct.jobLatGlobal = jobItem.jobLat
            DisplayStruct.jobLngGlobal = jobItem.jobLng
            DisplayStruct.jobTitleGlobal = jobItem.jobTitle
            DisplayStruct.jobURLGlobal = jobItem.jobURL
            
            self.performSegue(withIdentifier: self.homeToDisplay, sender: nil)
            
            print("selected Job: \(jobItem)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellSearch", for: indexPath)
        cell.selectionStyle = .none
        
        if jobItems.count > 0 {
            let jobData = jobItems[indexPath.row]
            cell.textLabel?.text = jobData.companyName
            cell.detailTextLabel?.text = jobData.jobTitle
        } else {
            let noData = noItems[indexPath.row]
            cell.textLabel?.text = noData
            cell.detailTextLabel?.text = " "
        }
        
        return cell
    }
    
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            cLLocationManager.requestLocation()
        } else {
            cLLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapLocationSet(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                             radius * 2.0, radius * 2.0)
        mapView.setRegion(coordinates, animated: true)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotate = view.annotation as? DisplayAnnotation {
            
            DisplayStruct.companyNameGlobal = annotate.companyName
            
            DisplayStruct.jobTitleGlobal = annotate.title!
            
            DisplayStruct.jobCityStateGlobal = annotate.cityState
            
            DisplayStruct.datePostedGlobal = annotate.datePosted
            
            DisplayStruct.jobLatGlobal = annotate.lat
            
            DisplayStruct.jobIDGlobal = annotate.id
            
            DisplayStruct.jobLngGlobal = annotate.lng
    
            DisplayStruct.jobURLGlobal = annotate.url
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotate = view.annotation as? DisplayAnnotation {
            
            DisplayStruct.companyNameGlobal = annotate.companyName
            //print(DisplayStruct.companyNameGlobal)
            
            DisplayStruct.jobTitleGlobal = annotate.title!
            //print(DisplayStruct.jobTitleGlobal)
            
            DisplayStruct.jobCityStateGlobal = annotate.cityState
            //print(DisplayStruct.jobCityStateGlobal)
            
            DisplayStruct.datePostedGlobal = annotate.datePosted
            //print(DisplayStruct.datePostedGlobal)
            
            DisplayStruct.jobLatGlobal = annotate.lat
            //print(DisplayStruct.jobLatGlobal)
            
            DisplayStruct.jobIDGlobal = annotate.id
            //print(DisplayStruct.jobIDGlobal)
            
            //String(format:"%.7f", annotate.lng)
            
            DisplayStruct.jobLngGlobal = annotate.lng
            //print(DisplayStruct.jobLngGlobal)
            
            DisplayStruct.jobURLGlobal = annotate.url
            //print(DisplayStruct.jobURLGlobal)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.homeToDisplay, sender: nil)
            }
        }
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        debugPrint("locationManager: didChangeAuthorizationStatus")
        if status == .authorizedWhenInUse {
            cLLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        debugPrint("locationManager: didUpdateLocations")
        
//        debugPrint(locations.first!)
        
        if let location = locations.first {
            
            let lat = location.coordinate.latitude as Double
            let lng = location.coordinate.longitude as Double
            
            let locationLatLong = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            mapLocationSet(location: locationLatLong)
            
            let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + String(lat) + "," + String(lng) + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
            
//            debugPrint("GeoCodeString COORDs: \(geoCodeString)")
            
            Alamofire.request(geoCodeString, method: .post).responseJSON { response in
                
//                debugPrint("response: \(response)")
                
                let jsonResponseGeo = response.data
                let jsonGeo = JSON(data: jsonResponseGeo!)
                
                let apiStatus = jsonGeo["status"].stringValue
//                debugPrint("apiStatus: \(apiStatus)")
                
                if apiStatus == "OVER_QUERY_LIMIT" {
                    let emptyFields = UIAlertController(title: "API Limit Error", message: "The application has exceeded the API limit usage for Geocoding api. We are aware of the issue and please be patient.", preferredStyle: UIAlertControllerStyle.alert)
                    emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(emptyFields, animated: true, completion: nil)
                } else if apiStatus == "OK" {
                    let jsonObjGeo = jsonGeo["results"].arrayValue.first
                    let jsonGeometry = jsonObjGeo?["address_components"].arrayValue
                    
                    for components in jsonGeometry! {
//                        debugPrint("components: \(components)")
                        
                        let addressType = components["types"].arrayValue
                        
                        for types in addressType {
//                            debugPrint("addressTypes: \(types.stringValue)")
                            if types.stringValue == "postal_code" {
                                
                                self.postalCodeLocation = components["long_name"].stringValue
//                                debugPrint("postalCode: \(self.postalCodeLocation)")
                                
                                if (!self.postalCodeLocation.isEmpty) && (!self.passUserLocationBool == false){
                                    self.locationInputTextField.text = self.postalCodeLocation
                                    self.passUserLocationBool = false
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getJobs(location: String, jobTitle: String, radius: String, sortColumns: String, sortOrder: String, pageSize: String, days: String) {
        let locationFix = location.replacingOccurrences(of: " ", with: "+")
        let locationFix2 = locationFix.replacingOccurrences(of: ",", with: "")
        
        let urlRequestString = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/" + jobTitle + "/" + locationFix2 + "/" + radius + "/" + sortColumns + "/" + sortOrder + "/" + "0" + "/" + pageSize + "/" + days + "/"
//        debugPrint("urlRequestString: \(urlRequestString)")
       
        if let annotations = self.mapView?.annotations {
            for _annotation in annotations {
                if let annotation = _annotation as? MKAnnotation
                {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
        
        let strGeoCodeLocInput = "https://maps.googleapis.com/maps/api/geocode/json?address=" + locationFix2 + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
        
//        debugPrint("GeoCodeString URL getJobs: \(strGeoCodeLocInput)")
        
        Alamofire.request(strGeoCodeLocInput, method: .post).responseJSON { response in
            
            let jsonResponseGeo = response.data
            let jsonGeo = JSON(data: jsonResponseGeo!)
            let jsonObjGeo = jsonGeo["results"].arrayValue
            for item in jsonObjGeo {
                let jsonGeometry = item["geometry"]
                
                let jsonLocation = jsonGeometry["location"]
                
                let jsonLatitude = jsonLocation["lat"].doubleValue
                let jsonLongitude = jsonLocation["lng"].doubleValue
                
                let locationLatLngInput = CLLocation(latitude: jsonLatitude, longitude: jsonLongitude)
                
                self.mapLocationSet(location: locationLatLngInput)
            }
            
        }
        
        Alamofire.request(urlRequestString, headers: headers).responseJSON { response in
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            let jsonObj = json["Jobs"]
            let jsonArrayVal = jsonObj.array
            
            if let _jsonArrayVal = jsonArrayVal {
                if _jsonArrayVal.isEmpty == false {
                    //print("JSON ARRAY AVAILABLE")
                    
                    //implement save search
                    self.saveSearchToFireBase(location: location, keyword: jobTitle, radius: radius, days: days)
                    
                    for item in jsonArrayVal! {
                        
                        let jobID = item["JvId"].stringValue
//                        print("JobID: \(jobID)")
                        
                        let jobTitle = item["JobTitle"].stringValue
//                        print("JobTitle: \(jobTitle)")
                        
                        let company = item["Company"].stringValue
//                        print("Company: \(company)")
                        
                        let accquisitionDate = item["AccquisitionDate"].stringValue
//                        print("AccquisitionDate: \(accquisitionDate)")
                        
                        let url = item["URL"].stringValue
//                        print("URL: \(url)")
                        
                        let jobURL = item["URL"].stringValue
//                        print("jobURL: \(jobURL)")
                        
                        let location = item["Location"].stringValue
//                        print("Location: \(location)")
                        
                        let newCompany = company.replacingOccurrences(of: " ", with: "+")
                        let newCompany2 = newCompany.replacingOccurrences(of: ",", with: "")
                        let newLocation = location.replacingOccurrences(of: " ", with: "+")
                        let newLocation2 = newLocation.replacingOccurrences(of: ",", with: "")
                        
                        let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany2 + "+" + newLocation2 + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                        
                        //debugPrint("GeoCodeString URL getJobs: \(geoCodeString)")
                        
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
                                                                      companyName: company,
                                                                      coordinate: CLLocationCoordinate2D(latitude: jsonLatitude, longitude: jsonLongitude),
                                                                      cityState: location,
                                                                      datePosted: accquisitionDate,
                                                                      id: jobID,
                                                                      lat: jsonLatitude,
                                                                      lng: jsonLongitude,
                                                                      url: url)
                                
                                self.mapView.addAnnotation(displayMarker)
                                
                                let locationLatLngInput = CLLocation(latitude: jsonLatitude, longitude: jsonLongitude)
                                print("locationLatLngInput: \(locationLatLngInput)")
                                
                                let latInfo = locationLatLngInput.coordinate.latitude
                                let lngInfo = locationLatLngInput.coordinate.longitude
                                
                                self.lat = latInfo
                                self.lng = lngInfo
                                
                                DisplayStruct.jobLatGlobal = self.lat
                                DisplayStruct.jobLngGlobal = self.lng
                            }
                        }
                        
                        let structItem = DisplayStruct(company: company, datePosted: accquisitionDate, jobCityState: location, jobID: jobID, jobLat: DisplayStruct.jobLatGlobal, jobLng: DisplayStruct.jobLngGlobal, jobTitle: jobTitle, jobURL: jobURL)
                        self.jobItems.append(structItem)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    //print("JSON ARRAY NOT AVAILABLE")
                    
                    let error = UIAlertController(title: "Error", message: "Error in API", preferredStyle: UIAlertControllerStyle.alert)
                    error.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(error, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    private func saveSearchToFireBase(location: String, keyword: String, radius: String, days: String) {
        var saveSearchList = self.searchSaveItems
        
        saveSearchList.removeAll()
        
        let dateTime = Date().timeIntervalSince1970 * 1000
//        debugPrint("dateTime: \(dateTime)")
        let dateTimeStringNoDec = String(format: "%.0f", dateTime)
//        debugPrint("dateTimeStringNoDec: \(dateTimeStringNoDec)")
        
        let saveSearchItem = SaveSearch(keywords: keyword, radius: radius, location: location, days: days, dateTime: dateTimeStringNoDec)
//        print("saveSearchItem: \(saveSearchItem)")
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
//        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
//        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
//        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedsearches")
        
//        print("listRef: \(listRef)")
        
        //let itemsRef = listRef.childByAutoId()
        //itemsRef.setValue(structItems.toAnyObject())
        
        let dateTimeStr = SaveSearch.dateTime
        
        let addChildStr = listRef.child(dateTimeStr)
//        print("addChildStr: \(addChildStr)")
        
        addChildStr.setValue(saveSearchItem.toAnyObject())
        
        saveSearchList.append(saveSearchItem)
//        debugPrint("saveSearchList: \(saveSearchList)")
    }

    
    @objc(locationManager:didFailWithError:)
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
