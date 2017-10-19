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
import GoogleMobileAds

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    var rootRef: FIRDatabaseReference!
    let listToHome = "listToHome"
    let listToProfile = "listToProfile"
    let listToLogin = "listToLogin"
    let listToDisplay = "listToDisplay"
    let listToSavedSearch = "listToSavedSearch"
    let listToSavedJobs = "listToSavedJobs"
    let listToAppliedJobs = "listToAppliedJobs"
    let radius: CLLocationDistance = 15000
    //let locationLatLong = CLLocation(latitude: 28.1749353, longitude: -82.355302)
    var typedLocation = false
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
    @IBOutlet weak var tableViewOutlet: UITableView!
    var passUserLocationBool : Bool = true
    @IBOutlet weak var bannerViewOutlet: GADBannerView!
    @IBOutlet weak var mapButtonOutlet: UIButton!
    @IBOutlet weak var listButtonOutlet: UIButton!
    
    var lat : Double = 0
    var lng : Double = 0
    
    
    var jobItems: [DisplayStruct] = []
    var searchSaveItems: [SaveSearch] = []
    
    var noItems = ["No jobs to display"]
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        listButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        mapButtonOutlet.setTitleColor(UIColor(hex: "CC0000"), for: UIControlState.normal)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,   // All simulators
            "e15b0e554146870aff4b7ef47282e61c" ];  // Sample device ID
        
        //bannerViewOutlet.adUnitID = "ca-app-pub-3940256099942544/6300978111" //test banner id
        bannerViewOutlet.adUnitID = "ca-app-pub-6204503397505906/2185014830" //real banner id
        bannerViewOutlet.rootViewController = self
        bannerViewOutlet.load(request)
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.distanceFilter = 500
        //cLLocationManager.stopUpdatingLocation()
        //cLLocationManager.delegate = nil
        
        //YNSavedSearchesView.SaveSearchValues.selected = "list"
        
        YNFilterView.FilterValues.radiusString = "20"
        YNFilterView.FilterValues.daysEntered = "30"
        YNFilterView.FilterValues.jobSort = "accquisitiondate"
        
        print("SaveSearch days from LIST: \(SaveSearch.days)")
        print("SaveSearch keywords from LIST: \(SaveSearch.keywords)")
        print("SaveSearch location from LIST: \(SaveSearch.location)")
        print("SaveSearch radius from LIST: \(SaveSearch.radius)")
        
        if !(SaveSearch.location.isEmpty || SaveSearch.location == "") {
            passUserLocationBool = false
            locationTextField.text = SaveSearch.location
        }
        
        if !(SaveSearch.keywords.isEmpty || SaveSearch.keywords == "") {
            jobTitleTextField.text = SaveSearch.keywords
        }
        
        if !(SaveSearch.days.isEmpty || SaveSearch.days == "") {
            YNFilterView.FilterValues.daysEntered = SaveSearch.days
            print("YNFilterView from SaveSearch days: \(YNFilterView.FilterValues.daysEntered)")
        }
        
        if !(SaveSearch.radius.isEmpty || SaveSearch.radius == "") {
            YNFilterView.FilterValues.radiusString = SaveSearch.radius
            print("YNFilterView from SaveSearch radius: \(YNFilterView.FilterValues.radiusString)")
        }
        
        let YNDropDown = Bundle.main.loadNibNamed("YNDropDown", owner: nil, options: nil) as? [UIView]
        if let _YNDropDown = YNDropDown {
            let frame = CGRect(x: 0, y: 62, width: UIScreen.main.bounds.size.width, height: 32)
            let view = YNDropDownMenu(frame: frame, dropDownViews: _YNDropDown, dropDownViewTitles: ["Filter"])
            self.view.addSubview(view)
        }
    
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
            
            self.performSegue(withIdentifier: self.listToDisplay, sender: nil)
            
            print("selected Job: \(jobItem)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
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
        
        //cell.imageView?.image = UIImage(named: )
        
        return cell
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.listToProfile, sender: nil)
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.listToHome, sender: nil)
    }
    
    @IBAction func savedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.listToSavedJobs, sender: nil)
    }
    
    @IBAction func appliedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.listToAppliedJobs, sender: nil)
    }
    
    public func listChangeViewToSavedSearches() {
        self.performSegue(withIdentifier: self.listToSavedSearch, sender: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let jobTitleEntered = jobTitleTextField.text
        let locationEntered = locationTextField.text
        //let postalCodeLoc = String(describing: postalCodeLocation)
        
        if jobTitleEntered != "" && locationEntered != "" {
            getJobs(location: locationEntered!, jobTitle: jobTitleEntered!, radius: YNFilterView.FilterValues.radiusString, sortColumns: YNFilterView.FilterValues.jobSort, sortOrder: "desc", pageSize: "100", days: YNFilterView.FilterValues.daysEntered)
        } else {
            let emptyFields = UIAlertController(title: "Error", message: "Enter text into location and job title fields", preferredStyle: UIAlertControllerStyle.alert)
            emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(emptyFields, animated: true, completion: nil)
        }

    }
    
    private func saveSearchToFireBase(location: String, keyword: String, radius: String, days: String) {
        var saveSearchList = self.searchSaveItems
        
        saveSearchList.removeAll()
        
        let dateTime = Date().timeIntervalSince1970 * 1000
        debugPrint("dateTime: \(dateTime)")
        let dateTimeStringNoDec = String(format: "%.0f", dateTime)
        debugPrint("dateTimeStringNoDec: \(dateTimeStringNoDec)")
        
        let saveSearchItem = SaveSearch(keywords: keyword, radius: radius, location: location, days: days, dateTime: dateTimeStringNoDec)
        print("saveSearchItem: \(saveSearchItem)")
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedsearches")
        
        print("listRef: \(listRef)")
        
        //let itemsRef = listRef.childByAutoId()
        //itemsRef.setValue(structItems.toAnyObject())
        
        let dateTimeStr = SaveSearch.dateTime
        
        let addChildStr = listRef.child(dateTimeStr)
        print("addChildStr: \(addChildStr)")
        
        addChildStr.setValue(saveSearchItem.toAnyObject())
        
        saveSearchList.append(saveSearchItem)
        debugPrint("saveSearchList: \(saveSearchList)")
    }
    
    @IBAction func savedSearchesAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.listToSavedSearch, sender: nil)
    }
    
    
    @IBAction func currLocationAction(_ sender: UIButton) {
        debugPrint("currLocationAction")
        
        passUserLocationBool = true
        print("passUserLocationBool: \(passUserLocationBool)")
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
                self.performSegue(withIdentifier: self.listToLogin, sender: nil)
                //debugPrint(user?.email! as Any)
            }
        }
        
        rootRef = FIRDatabase.database().reference()
        
    }
    
    
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //debugPrint("checkUserLocationStatus - authorizedWhenInUse")
            cLLocationManager.requestLocation()
        } else {
            //debugPrint("checkUserLocationStatus - requestWhenInUseAuthorization")
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
    
    func getJobs(location: String, jobTitle: String, radius: String, sortColumns: String, sortOrder: String, pageSize: String, days: String) {
        let locationFix = location.replacingOccurrences(of: " ", with: "+")
        let locationFix2 = locationFix.replacingOccurrences(of: ",", with: "")
        
        //                                                                      user id         keyword         location        radius          sortColumns        sortOrder       startRecord   pageSize       days
        let urlRequestString = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/" + jobTitle + "/" + locationFix2 + "/" + radius + "/" + sortColumns + "/" + sortOrder + "/" + "0" + "/" + pageSize + "/" + days + "/"
        debugPrint("urlRequestString: \(urlRequestString)")
        
        Alamofire.request(urlRequestString, headers: headers).responseJSON { response in
            //debugPrint("Alamofire response 2: \(response)")
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            debugPrint("json: \(json)")
            let jsonObj = json["Jobs"]
            debugPrint("jsonObj: \(jsonObj)")
            
            //check if jsonArrayVal is null for data
            let jsonArrayVal = jsonObj.array
            debugPrint("jsonArrayVal: \(jsonArrayVal!)")
            
            if let _jsonArrayVal = jsonArrayVal {
                if _jsonArrayVal.isEmpty == false {
                    //debugPrint("COUNTER FOR ARRAY: \(String(describing: jsonArrayVal?.count))")
                    print("JSON ARRAY AVAILABLE")
                    
                    //implement save search
                    self.saveSearchToFireBase(location: location, keyword: jobTitle, radius: radius, days: days)
                    
                    for item in jsonArrayVal! {
                        print("item: \(item)")
                        
                        let jobID = item["JvId"].stringValue
                        print("JobID: \(jobID)")
                        
                        let jobTitle = item["JobTitle"].stringValue
                        print("JobTitle: \(jobTitle)")
                        
                        let company = item["Company"].stringValue
                        print("Company: \(company)")
                        
                        let accquisitionDate = item["AccquisitionDate"].stringValue
                        print("AccquisitionDate: \(accquisitionDate)")
                        
                        let jobURL = item["URL"].stringValue
                        print("jobURL: \(jobURL)")
                        
                        debugPrint("jobItems: \(self.jobItems)")
                        debugPrint("jobItems Count: \(self.jobItems.count)")
                        
                        let location = item["Location"].stringValue
                        print("Location: \(location)")
                        
                        let newCompany = company.replacingOccurrences(of: " ", with: "+")
                        let newCompany2 = newCompany.replacingOccurrences(of: ",", with: "")
                        let newLocation = location.replacingOccurrences(of: " ", with: "+")
                        let newLocation2 = newLocation.replacingOccurrences(of: ",", with: "")
                        
                        let strGeoCodeLocInput = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany2 + "+" + newLocation2 + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                        
                        debugPrint("GeoCodeString URL getJobs: \(strGeoCodeLocInput)")
                        
                        Alamofire.request(strGeoCodeLocInput, method: .post).responseJSON { response in
                            
                            //debugPrint("Alamofire response 1: \(strGeoCodeLocInput)")
                            
                            let jsonResponseGeo = response.data
                            let jsonGeo = JSON(data: jsonResponseGeo!)
                            let jsonObjGeo = jsonGeo["results"].arrayValue
                            for item in jsonObjGeo {
                                let jsonGeometry = item["geometry"]
                                
                                let jsonLocation = jsonGeometry["location"]
                                
                                let jsonLatitude = jsonLocation["lat"].doubleValue
                                let jsonLongitude = jsonLocation["lng"].doubleValue
                                
                                
                                //debugPrint("Location Lat: \(jsonLatitude)")
                                //debugPrint("Location Lng: \(jsonLongitude)")
                                
                                let locationLatLngInput = CLLocation(latitude: jsonLatitude, longitude: jsonLongitude)
                                print("locationLatLngInput: \(locationLatLngInput)")
                                
                                let latInfo = locationLatLngInput.coordinate.latitude
                                let lngInfo = locationLatLngInput.coordinate.longitude
                                
                                self.lat = latInfo
                                self.lng = lngInfo
                                
                                //let latString:String = String(format:"%.7f", self.lat)
                                //let lngString:String = String(format:"%.7f", self.lng)
                                
                                //DispatchQueue.main.async {
                                DisplayStruct.jobLatGlobal = self.lat
                                DisplayStruct.jobLngGlobal = self.lng
                                //}
                                
                                print("latString: \(DisplayStruct.jobLatGlobal)")
                                print("lngString: \(DisplayStruct.jobLngGlobal)")
                            }
                            
                        }
                        
                        print("latString2: \(DisplayStruct.jobLatGlobal)")
                        print("lngString2: \(DisplayStruct.jobLngGlobal)")
                        
                        let structItem = DisplayStruct(company: company, datePosted: accquisitionDate, jobCityState: location, jobID: jobID, jobLat: DisplayStruct.jobLatGlobal, jobLng: DisplayStruct.jobLngGlobal, jobTitle: jobTitle, jobURL: jobURL)
                        self.jobItems.append(structItem)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.tableViewOutlet.reloadData()
                    }
                } else {
                    print("JSON ARRAY NOT AVAILABLE")
                    
                    let error = UIAlertController(title: "Error", message: "Error in API", preferredStyle: UIAlertControllerStyle.alert)
                    error.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(error, animated: true, completion: nil)
                }
            }
            
            print("jobItems: \(self.jobItems)")
            
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
                                
                                if (!self.postalCodeLocation.isEmpty) && (!self.passUserLocationBool == false){
                                    self.locationTextField.text = self.postalCodeLocation
                                    self.passUserLocationBool = false
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
