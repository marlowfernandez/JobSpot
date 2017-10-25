//
//  ViewController.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    let mainToCreateAcc = "mainToCreateAcc"
    let mainToHome = "mainToHome"
    var handle: FIRAuthStateDidChangeListenerHandle?
    var email : String = " "
    var rootRef: FIRDatabaseReference!
    
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootRef = FIRDatabase.database().reference()
        
        loginOutlet.backgroundColor = UIColor(hex: "CC0000")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.dismissKeyboardTapped()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonLogin(_ sender: UIButton) {
        debugPrint("button login pressed")
        
        email = emailAddress.text!
        let password = inputPassword.text
        
        if email != "" && password != "" {
            FIRAuth.auth()?.signIn(withEmail: email, password: password!) { (user, error) in
                if error != nil {
                    debugPrint("not able to login")
                    
                    let loginError = UIAlertController(title: "Login Error", message: "Error logging in: "+(error?.localizedDescription)!+" Do you have an account? Please register", preferredStyle: UIAlertControllerStyle.alert)
                    loginError.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(loginError, animated: true, completion: nil)
                    
                    return
                }
                debugPrint("able to login")
                //self.performSegue(withIdentifier: self.mainToHome, sender: nil)
            }
            
            
            debugPrint(email,password!)
            emailAddress.text = ""
            inputPassword.text = ""
        } else {
            let emptyFields = UIAlertController(title: "Error", message: "Enter text into email and/or password fields", preferredStyle: UIAlertControllerStyle.alert)
            emptyFields.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(emptyFields, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func registerButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.mainToCreateAcc, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear")
        
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                let usersRef = self.rootRef.child("users")
                let idRef = usersRef.child(userID!)
                let listRef = idRef.child("email")
                
                //TODO: check if email name is already there before setting...
                //listRef.setValue(self.email)
                
                self.performSegue(withIdentifier: self.mainToHome, sender: nil)
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

extension UIViewController {
    func dismissKeyboardTapped() {
        let tapBG: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapBG.cancelsTouchesInView = false
        view.addGestureRecognizer(tapBG)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

