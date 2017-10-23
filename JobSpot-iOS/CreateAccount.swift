//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase

class CreateAccount: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    var handle: FIRAuthStateDidChangeListenerHandle?
    let createAccToHome = "createAccToHome"
    let createAccToLogin = "createAccToLogin"
    var email : String = " "
    var rootRef: FIRDatabaseReference!
    
    @IBOutlet weak var createAccOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        createAccOutlet.backgroundColor = UIColor(hex: "CC0000")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        email = emailAddress.text!
        let password = inputPassword.text
        
        if email != "" && password != "" {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password!) { (user, error) in
                if let error = error {
                    
                    let createError = UIAlertController(title: "Account Creation Error", message: "\(error.localizedDescription) Please try again with a different email.", preferredStyle: UIAlertControllerStyle.alert)
                    createError.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(createError, animated: true, completion: nil)
                    
                    return
                }
                debugPrint("\(user!.email!) was created")
            }
            
            debugPrint(email,password!)
            emailAddress.text = ""
            inputPassword.text = ""
        } else {
            
            let emptyFields = UIAlertController(title: "Error", message: "Enter text into email and/or password fields", preferredStyle: UIAlertControllerStyle.alert)
            emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(emptyFields, animated: true, completion: nil)
            
            debugPrint("registerButton not successful")
        }
    }
    
    
    @IBAction func actionLogin(_ sender: Any) {
        self.performSegue(withIdentifier: self.createAccToLogin, sender: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear")
        
        rootRef = FIRDatabase.database().reference()
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                
                //firebase.child("users").child(firebaseUser.getUid()).child("email").setValue(email);
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                let usersRef = self.rootRef.child("users")
                let idRef = usersRef.child(userID!)
                let listRef = idRef.child("email")
                listRef.setValue(self.email)
                
                self.performSegue(withIdentifier: self.createAccToHome, sender: nil)
                debugPrint(user?.email! as Any)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDisappear")
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
}

