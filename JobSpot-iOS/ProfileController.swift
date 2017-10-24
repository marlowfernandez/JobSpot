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
    
    var rootRef: FIRDatabaseReference!
    var listRef: FIRDatabaseReference!
    
    @IBOutlet weak var fullNameOutlet: UILabel!
    @IBOutlet weak var headlineOutlet: UILabel!
    @IBOutlet weak var emailOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var profileImageOutlet: UIImageView!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var editProfileButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        fullNameOutlet.text = "N/A"
        headlineOutlet.text = "N/A"
        emailOutlet.text = "N/A"
        locationOutlet.text = "N/A"
        summaryOutlet.text = "N/A"
        
        logoutButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        editProfileButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = self.rootRef.child("users")
        let idRef = usersRef.child(userID!)
        listRef = idRef.child("userProfile")
        
//        if ProfileStruct.fullNameProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.fullNameOutlet.text = ProfileStruct.fullNameProf
//        }
//        
//        if ProfileStruct.headlineProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.headlineOutlet.text = ProfileStruct.headlineProf
//        }
//        
//        if ProfileStruct.locationProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.locationOutlet.text = ProfileStruct.locationProf
//        }
//        
//        if ProfileStruct.summaryProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.summaryOutlet.text = ProfileStruct.summaryProf
//        }
//        
//        if ProfileStruct.emailProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.emailOutlet.text = ProfileStruct.emailProf
//        }
//        
//        let urlPic = URL(string: ProfileStruct.pictureProf)
//        if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 1 {
//            let dataFromPic = try? Data(contentsOf: urlPic!)
//            self.profileImageOutlet.image = UIImage(data: dataFromPic!)
//            self.profileImageOutlet.setNeedsDisplay()
//        }
        
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
        
//        if ProfileStruct.fullNameProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.fullNameOutlet.text = ProfileStruct.fullNameProf
//        }
//        
//        if ProfileStruct.headlineProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.headlineOutlet.text = ProfileStruct.headlineProf
//        }
//        
//        if ProfileStruct.locationProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.locationOutlet.text = ProfileStruct.locationProf
//        }
//        
//        if ProfileStruct.summaryProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.summaryOutlet.text = ProfileStruct.summaryProf
//        }
//        
//        if ProfileStruct.emailProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//            self.emailOutlet.text = ProfileStruct.emailProf
//        }
//        
//        let urlPic = URL(string: ProfileStruct.pictureProf)
//        if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 1 {
//            let dataFromPic = try? Data(contentsOf: urlPic!)
//            self.profileImageOutlet.image = UIImage(data: dataFromPic!)
//        }
        
        listRef.observe(.value, with: { snapshot in
            
            if snapshot.childrenCount == 0 {
                self.fullNameOutlet.text = "N/A"
                self.headlineOutlet.text = "N/A"
                self.emailOutlet.text = "N/A"
                self.locationOutlet.text = "N/A"
                self.summaryOutlet.text = "N/A"
            } else {
                for item in snapshot.children {
                    debugPrint("item children: \(item)")
                    
                    let profileItem = ProfileStruct(snapshot: item as! FIRDataSnapshot)
                    print("profileItem: \(profileItem)")
                    
                    print("name \(profileItem.fullNameSave)")
                    print("email \(profileItem.emailSave)")
                    print("location \(profileItem.locationSave)")
                    print("headline \(profileItem.headlineSave)")
                    print("summary \(profileItem.summarySave)")
                    print("picture \(profileItem.pictureSave)")
                    
                    ProfileStruct.fullNameProf = profileItem.fullNameSave
                    ProfileStruct.headlineProf = profileItem.headlineSave
                    ProfileStruct.locationProf = profileItem.locationSave
                    ProfileStruct.summaryProf = profileItem.summarySave
                    ProfileStruct.pictureProf = profileItem.pictureSave
                    ProfileStruct.emailProf = profileItem.emailSave
                    
                    DispatchQueue.main.async {
                            self.emailOutlet.text = ProfileStruct.emailProf
                            self.fullNameOutlet.text = ProfileStruct.fullNameProf
                            self.summaryOutlet.text = ProfileStruct.summaryProf
                            self.headlineOutlet.text = ProfileStruct.headlineProf
                            self.locationOutlet.text = ProfileStruct.locationProf
                        
                            let urlPic = URL(string: ProfileStruct.pictureProf)
                            if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 5 {
                            
                                let dataFromPic = try? Data(contentsOf: urlPic!)
                                self.profileImageOutlet.image = UIImage(data: dataFromPic!)
                                self.profileImageOutlet.setNeedsDisplay()
                            }
                    }
                }
            }
            
        })

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listRef.removeAllObservers()
    }
    
    @IBAction func signInLinkedIn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Profile", message: "Would you like to use your LinkedIn information for your profile?", preferredStyle: .alert)
        
        let linkedInAction = UIAlertAction(title: "Yes", style: .default) { (action) in
        
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
                        
//                        let email = jsonResponseLIData["email"].stringValue
//                        if email.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//                            self.email = email
//                        }
                        
                        print("formattedName: \(jsonResponseLIData["formattedName"].stringValue)") //
                        print("headline: \(jsonResponseLIData["headline"].stringValue)") //
                        print("summary: \(jsonResponseLIData["summary"].stringValue))") //
                        print("location: \(jsonResponseLIData["location"].arrayValue)") //
                        for locationResults in jsonResponseLIData["location"].arrayValue{
                            
                            print("locationResults \(locationResults)")
                        }
                        print("pictureUrl: \(jsonResponseLIData["pictureUrl"].stringValue)") //
                        print("email: \(jsonResponseLIData["email"].stringValue)") //
                        
//                        let profileStructItem = ProfileStruct(fullName: self.fullName, headline: self.headline, location: self.location, summary: self.summary, picture: self.picture, email: ProfileStruct.emailProf)
                        
                        let profileItem = ProfileStruct(fullNameNew: self.fullName, headlineNew: self.headline, locationNew: self.location, summaryNew: self.summary, pictureNew: self.picture, emailNew: ProfileStruct.emailProf)
    //                    print("profileItem: \(profileItem.fullName)")
                        
//                        let userID = FIRAuth.auth()?.currentUser?.uid
//                        
//                        let usersRef = self.rootRef.child("users")
//                        
//                        let idRef = usersRef.child(userID!)
//                        
//                        let listRef = idRef.child("userProfile")
                        
                        self.listRef.observe(.value, with: { snapshot in
                            print(snapshot.childrenCount)
                            
                            if snapshot.childrenCount == 0 {
                                let addChildStr = self.listRef.childByAutoId()
                                addChildStr.setValue(profileItem.toAnyObject())
                                
                                ProfileStruct.fullNameProf = profileItem.fullNameSave
                                ProfileStruct.headlineProf = profileItem.headlineSave
                                ProfileStruct.locationProf = profileItem.locationSave
                                ProfileStruct.summaryProf = profileItem.summarySave
                                ProfileStruct.pictureProf = profileItem.pictureSave
                                
                                DispatchQueue.main.async {
                                    self.fullNameOutlet.text = ProfileStruct.fullNameProf
                                    self.headlineOutlet.text = ProfileStruct.headlineProf
                                    self.locationOutlet.text = ProfileStruct.locationProf
                                    self.summaryOutlet.text = ProfileStruct.summaryProf
                                    
                                    let urlPic = URL(string: ProfileStruct.pictureProf)
                                    if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                                        let dataFromPic = try? Data(contentsOf: urlPic!)
                                        self.profileImageOutlet.image = UIImage(data: dataFromPic!)
                                    }
                                }
                                
                                
                                
                            } else {
                                for item in snapshot.children {
                                    
                                    let profileItem = ProfileStruct(snapshot: item as! FIRDataSnapshot)
                                    print("profileItem: \(profileItem)")
                                    
                                    let ref = profileItem.ref
                                    print("ref from Profile: \(String(describing: ref))")
                                    
//                                    ref?.updateChildValues(["email": self.email])
                                    ref?.updateChildValues(["fullName": self.fullName])
                                    ref?.updateChildValues(["headline": self.headline])
                                    ref?.updateChildValues(["location": self.location])
                                    ref?.updateChildValues(["picture": self.picture])
                                    ref?.updateChildValues(["summary": self.summary])
                                    
                                    ProfileStruct.fullNameProf = self.fullName
                                    ProfileStruct.headlineProf = self.headline
                                    ProfileStruct.locationProf = self.location
                                    ProfileStruct.summaryProf = self.summary
                                    ProfileStruct.pictureProf = self.picture
//                                    ProfileStruct.emailProf = self.email
                                    
//                                    DispatchQueue.main.async {
//                                        self.fullNameOutlet.text = self.fullName
//                                        self.headlineOutlet.text = self.headline
//                                        self.locationOutlet.text = self.location
//                                        self.summaryOutlet.text = self.summary
//                                        self.emailOutlet.text = self.email
//                                        
//                                        let urlPic = URL(string: self.picture)
//                                        debugPrint("urlPic: \(String(describing: urlPic))")
//                                        if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//                                            let dataFromPic = try? Data(contentsOf: urlPic!)
//                                            self.profileImageOutlet.image = UIImage(data: dataFromPic!)
//                                            self.profileImageOutlet.setNeedsDisplay()
//                                        }
//                                    }
                                    
                                }
                            }
                        })

                            
    //                    ProfileStruct.fullNameProf = profileStructItem.fullName
    //                    ProfileStruct.headlineProf = profileStructItem.headline
    //                    ProfileStruct.locationProf = profileStructItem.location
    //                    ProfileStruct.summaryProf = profileStructItem.summary
    //                    ProfileStruct.pictureProf = profileStructItem.picture
    //                    ProfileStruct.emailProf = profileStructItem.email
                        
                        
                            
                            
                    }, error: { (error) in
                        debugPrint("error respon API Linkedin: \(error!)")
                    })
                }
            }
            ) { (error) in
                debugPrint("error: \(String(describing: error))")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(linkedInAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
            
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
