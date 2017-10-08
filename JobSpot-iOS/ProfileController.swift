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

class ProfileController: UIViewController {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    let logout = "logout"
    let profileToHome = "profileToHome"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        
        
        //self.performSegue(withIdentifier: self.logout, sender: nil)
        
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
        
//        let linkedinHelper = LinkedinSwiftHelper(configuration:
//            
//            LinkedinSwiftConfiguration(clientId: "", clientSecret: "", state: "", permissions: ["",""])
//        )
//        
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {(success) in
                let session = LISDKSessionManager.sharedInstance().session
            
                let url = "https://api.linkedin.com/v1/people/~"
                debugPrint("url linkedin: \(url)")
            
                if(LISDKSessionManager.hasValidSession()){
                    LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
                        debugPrint("response API linkedin: \(response?.data! as Any)")
                    }, error: { (error) in
                        debugPrint("error respon API Linkedin: \(error!)")
                    })
                }
            }
        ) { (error) in
            debugPrint("error: \(String(describing: error))")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear")
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    @IBAction func profileToHome(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.profileToHome, sender: nil)
    }
    
    
    
}

