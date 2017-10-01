//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    let logout = "logout"
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear")
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
}

