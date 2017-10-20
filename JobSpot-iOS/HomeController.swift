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

class HomeController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    var rootRef: FIRDatabaseReference!
    let homeToProfile = "homeToProfile"
    let homeToLogin = "homeToLogin"
    let homeToList = "homeToList"
    let homeToSavedSearch = "homeToSavedSearch"
    let homeToDisplay = "homeToDisplay"
    let homeToSavedJobs = "homeToSavedJobs"
    let homeToAppliedJobs = "homeToAppliedJobs"
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
    @IBOutlet weak var bannerViewOutlet: GADBannerView!
    @IBOutlet weak var mapButtonOutlet: UIButton!
    @IBOutlet weak var listButtonOutlet: UIButton!
    
    
    var passUserLocationBool : Bool = true
    
    var searchSaveItems: [SaveSearch] = []
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer imXBBrutJKGqrj6NHkLNPA41F8H/dbvQDiYjpaLrQWmYzJb+PNAZ7dg8D6Gv7onpkZl1mccgSRygH+xiE7AZrQ==",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.dismissKeyboardTapped()
        
        mapButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        listButtonOutlet.setTitleColor(UIColor(hex: "CC0000"), for: UIControlState.normal)
        
//        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID,   // All simulators
//            "e15b0e554146870aff4b7ef47282e61c" ];  // Sample device ID
//        
//        bannerViewOutlet.adUnitID = "ca-app-pub-6204503397505906/2185014830" //real banner id
//        bannerViewOutlet.rootViewController = self
//        bannerViewOutlet.load(request)
        
        mapViewOutlet.delegate = self
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.distanceFilter = 500
        //cLLocationManager.stopUpdatingLocation()
        //cLLocationManager.delegate = nil
        
        //YNSavedSearchesView.SaveSearchValues.selected = "map"
        
        YNFilterView.FilterValues.radiusString = "20"
        YNFilterView.FilterValues.daysEntered = "30"
        YNFilterView.FilterValues.jobSort = "accquisitiondate"
        
        print("SaveSearch days from HOME: \(SaveSearch.days)")
        print("SaveSearch keywords from HOME: \(SaveSearch.keywords)")
        print("SaveSearch location from HOME: \(SaveSearch.location)")
        print("SaveSearch radius from HOME: \(SaveSearch.radius)")
        
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
            let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 32)
            let view = YNDropDownMenu(frame: frame, dropDownViews: _YNDropDown, dropDownViewTitles: ["Filter"])
            view.setLabelColorWhen(normal: UIColor(hex: "CC0000"), selected: UIColor(hex: "000000"), disabled: UIColor(hex: "CC0000"))
            view.setLabelFontWhen(normal: UIFont.boldSystemFont(ofSize: 14), selected: UIFont.boldSystemFont(ofSize: 14), disabled: UIFont.boldSystemFont(ofSize: 14))
            
            let image = self.ResizeImage(image: UIImage(named: "filter")!, changeSizeTo: CGSize(30.0, 30.0)) as UIImage
            view.setImageWhen(normal: image, selected: image, disabled: image)
            self.view.addSubview(view)
        }
        
    
    }
    
    public func receiveRadius() -> String {
        
        
        return ""
    }
    
    public func mapChangeViewToSavedSearches() {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.performSegue(withIdentifier: self.homeToSavedSearch, sender: nil)
        }
        
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToProfile, sender: nil)
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let jobTitleEntered = jobTitleTextField.text
        let locationEntered = locationTextField.text
        
        if jobTitleEntered != "" && locationEntered != "" {
            getJobs(location: locationEntered!, jobTitle: jobTitleEntered!, radius: YNFilterView.FilterValues.radiusString, sortColumns: YNFilterView.FilterValues.jobSort, sortOrder: "desc", pageSize: "200", days: YNFilterView.FilterValues.daysEntered)
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
                self.performSegue(withIdentifier: self.homeToLogin, sender: nil)
                //debugPrint(user?.email! as Any)
            }
        }
        
        rootRef = FIRDatabase.database().reference()
        
    }
    
    
    func mapLocationSet(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  radius * 2.0, radius * 2.0)
        mapViewOutlet.setRegion(coordinates, animated: true)
    }
    
    
    func checkUserLocationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //debugPrint("checkUserLocationStatus - authorizedWhenInUse")
            mapViewOutlet.showsUserLocation = true
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
    
    @IBAction func listActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToList, sender: nil)
    }
    
    @IBAction func savedJobsActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToSavedJobs, sender: nil)
    }
    
    @IBAction func appliedJobsActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.homeToAppliedJobs, sender: nil)
    }
    
    
    
    func getJobs(location: String, jobTitle: String, radius: String, sortColumns: String, sortOrder: String, pageSize: String, days: String) {
        let locationFix = location.replacingOccurrences(of: " ", with: "+")
        let locationFix2 = locationFix.replacingOccurrences(of: ",", with: "")
        
        //                                                                      user id         keyword         location        radius          sortColumns        sortOrder       startRecord   pageSize       days
        let urlRequestString = "https://api.careeronestop.org/v1/jobsearch/TZ1zgEyKTNm69nF/" + jobTitle + "/" + locationFix2 + "/" + radius + "/" + sortColumns + "/" + sortOrder + "/" + "0" + "/" + pageSize + "/" + days + "/"
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
        
        let strGeoCodeLocInput = "https://maps.googleapis.com/maps/api/geocode/json?address=" + locationFix2 + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
        
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

                
                self.mapLocationSet(location: locationLatLngInput)
            }
            
        }
    

        
        Alamofire.request(urlRequestString, headers: headers).responseJSON { response in
            //debugPrint("Alamofire response 2: \(response)")
            let jsonResponse = response.data
            let json = JSON(data: jsonResponse!)
            let jsonObj = json["Jobs"]
            let jsonArrayVal = jsonObj.array
            
            if let _jsonArrayVal = jsonArrayVal {
                if _jsonArrayVal.isEmpty == false {
                    print("JSON ARRAY AVAILABLE")
                    
                    //implement save search
                    self.saveSearchToFireBase(location: location, keyword: jobTitle, radius: radius, days: days)
                    
                    //debugPrint("COUNTER FOR ARRAY: \(String(describing: jsonArrayVal?.count))")
                    
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
                        
                        let newCompany = company.replacingOccurrences(of: " ", with: "+")
                        let newCompany2 = newCompany.replacingOccurrences(of: ",", with: "")
                        let newLocation = location.replacingOccurrences(of: " ", with: "+")
                        let newLocation2 = newLocation.replacingOccurrences(of: ",", with: "")
                        
                        let geoCodeString = "https://maps.googleapis.com/maps/api/geocode/json?address=" + newCompany2 + "+" + newLocation2 + "&key=AIzaSyAFR4nAy-FpaCoAFTP3v_FdjPHLxtK3ovk"
                        
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
                                                                      companyName: company,
                                                                      coordinate: CLLocationCoordinate2D(latitude: jsonLatitude, longitude: jsonLongitude),
                                                                      cityState: location,
                                                                      datePosted: accquisitionDate,
                                                                      id: jobID,
                                                                      lat: jsonLatitude,
                                                                      lng: jsonLongitude,
                                                                      url: url)
                                
                                self.mapViewOutlet.addAnnotation(displayMarker)
                            }
                            
                        }
                        
                    }
                } else {
                    print("JSON ARRAY NOT AVAILABLE")
                    
                    let error = UIAlertController(title: "Error", message: "Error in API", preferredStyle: UIAlertControllerStyle.alert)
                    error.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(error, animated: true, completion: nil)
                }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
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
    
    func ResizeImage(image: UIImage, changeSizeTo: CGSize) -> UIImage {
        let size = image.size
        
        let width  = changeSizeTo.width  / image.size.width
        let height = changeSizeTo.height / image.size.height
        
        var newImageSize: CGSize
        if(width > height) {
            newImageSize = CGSize(size.width * height, size.height * height)
        } else {
            newImageSize = CGSize(size.width * width,  size.height * width)
        }
        
        let cgRect = CGRect(0, 0, newImageSize.width, newImageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, 1.0)
        image.draw(in: cgRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}


