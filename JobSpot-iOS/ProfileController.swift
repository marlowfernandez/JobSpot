//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase
import LinkedinSwift
import Alamofire
import SwiftyJSON

class ProfileController: UIViewController {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    let logout = "logout"
    let profileToHome = "profileToHome"
    let profileToAppliedJobs = "profileToAppliedJobs"
    let profileToSavedJobs = "profileToSavedJobs"
    var fullName : String = " "
    var email : String = " "
    var headline : String = " "
    var location : String = " "
    var summary : String = " "
    var picture : String = " "
    
    @IBOutlet weak var fullNameOutlet: UILabel!
    @IBOutlet weak var headlineOutlet: UILabel!
    @IBOutlet weak var emailOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var profileImageOutlet: UIImageView!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        fullNameOutlet.text = " "
        headlineOutlet.text = " "
        emailOutlet.text = " "
        locationOutlet.text = " "
        summaryOutlet.text = " "
        
        logoutButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear")
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user == nil {
                self.performSegue(withIdentifier: self.logout, sender: nil)
                
            }
        }
    }
    
    @IBAction func signInLinkedIn(_ sender: UIButton) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {(success) in
                //let session = LISDKSessionManager.sharedInstance().session
            
                //let url = "https://api.linkedin.com/v1/people/~"
            //let url = "https://api.linkedin.com/v1/people/~:(formatted-name,email-address,headline,location,industry,summary,picture-url)"
                //debugPrint("url linkedin: \(url)")
            
            let urlJson = "https://api.linkedin.com/v1/people/~:(formatted-name,email-address,headline,location,industry,summary,picture-url)?format=json"
            
//            Alamofire.request(urlJson, method: .post).responseJSON { response in
//            
//                let jsonResponseLI = response.data
//                let jsonResponseLIData = JSON(data: jsonResponseLI!)
//                
//                debugPrint("jsonResponseLIData: \(jsonResponseLIData)")
//            
//            }
//            
            
            if(LISDKSessionManager.hasValidSession()){
                LISDKAPIHelper.sharedInstance().getRequest(urlJson, success: { (response) in
                    //print("response API linkedin: \(self.convertToDictionary(input: (response?.data)!)!)")
                    
                    let jsonResponseLI = response?.data.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    
                    let jsonResponseLIData = JSON(data: jsonResponseLI!)
                    
                    let formattedName = jsonResponseLIData["formattedName"].stringValue
                    if formattedName.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                        self.fullName = formattedName
                    }
                    
                    let headline = jsonResponseLIData["headline"].stringValue
                    if headline.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                        self.headline = headline
                    }
                    
                    let summary = jsonResponseLIData["summary"].stringValue
                    if summary.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                        self.summary = summary
                    }
                    
                    let pictureUrl = jsonResponseLIData["pictureUrl"].stringValue
                    if pictureUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                        self.picture = pictureUrl
                    }
                    
                    let email = jsonResponseLIData["email"].stringValue
                    if email.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                        self.email = email
                    }
                    
                    print("formattedName: \(jsonResponseLIData["formattedName"].stringValue)") //
                    print("headline: \(jsonResponseLIData["headline"].stringValue)") //
                    print("summary: \(jsonResponseLIData["summary"].stringValue))") //
                    print("location: \(jsonResponseLIData["location"].arrayValue)") //
                    for locationResults in jsonResponseLIData["location"].arrayValue{
                        
                        print("locationResults \(locationResults)")
                    }
                    print("pictureUrl: \(jsonResponseLIData["pictureUrl"].stringValue)") //
                    print("email: \(jsonResponseLIData["email"].stringValue)") //
                    
                    //print(jsonResponseLIData)
//                    let responseDict = self.convertToDictionary(input: (response?.data)!)
//                    
//                    if responseDict?["formattedName"] != nil {
//                        self.fullName = responseDict?["formattedName"] as! String
//                        print("fullName: \(self.fullName))")
//                    }
//                        
//                    if responseDict?["headline"] != nil {
//                        self.headline = responseDict?["headline"] as! String
//                        print("headline: \(self.headline))")
//                    }
//                        
//                    if responseDict?["location"] != nil {
//                        let locationDict = responseDict?["location"]
//                        //let locationName = self.convertToDictionary(input: locationDict as! String)
//                        //self.location = locationName?["location"] as! String
//                        
//                        
//                        //print("location: \(self.location))")
//                        print("locationName: \(locationDict!)")
//                    }
//                        
//                    if responseDict?["summary"] != nil {
//                        self.summary = responseDict?["summary"] as! String
//                        print("summary: \(self.summary)")
//                    }
//                        
//                    if responseDict?["pictureUrl"] != nil {
//                        self.picture = responseDict?["pictureUrl"] as! String
//                        print("pictureUrl: \(self.picture)")
//                    }
//                        
//                    if responseDict?["emailAddress"] != nil {
//                        self.email = responseDict?["emailAddress"] as! String
//                        print("emailAddress: \(self.email)")
//                    }
                    
                    let profileStructItem = ProfileStruct(fullName: self.fullName, headline: self.headline, location: self.location, summary: self.summary, picture: self.picture, email: self.email)
                        
                    //print("profileStructItem: \(profileStructItem)")
                        
                    ProfileStruct.fullNameProf = profileStructItem.fullName
                    ProfileStruct.headlineProf = profileStructItem.headline
                    ProfileStruct.locationProf = profileStructItem.location
                    ProfileStruct.summaryProf = profileStructItem.summary
                    ProfileStruct.pictureProf = profileStructItem.picture
                    ProfileStruct.emailProf = profileStructItem.email
                    
                    DispatchQueue.main.async {
                        self.fullNameOutlet.text = ProfileStruct.fullNameProf
                        self.headlineOutlet.text = ProfileStruct.headlineProf
                        self.locationOutlet.text = ProfileStruct.locationProf
                        self.summaryOutlet.text = ProfileStruct.summaryProf
                        self.emailOutlet.text = ProfileStruct.emailProf
                        
                        let urlPic = URL(string: ProfileStruct.pictureProf)
                        if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                            let dataFromPic = try? Data(contentsOf: urlPic!)
                            self.profileImageOutlet.image = UIImage(data: dataFromPic!)
                        }
                    }
                        
                        
                }, error: { (error) in
                    debugPrint("error respon API Linkedin: \(error!)")
                })
            }
        }
        ) { (error) in
            debugPrint("error: \(String(describing: error))")
        }
    }
    
    func convertToDictionary(input: String)-> [String:Any]?{
        if let info = input.data(using: .utf8){
            do {
                return try JSONSerialization.jsonObject(with: info, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear")
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
}
