//
//  EditProfile.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/22/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class EditProfile: UIViewController, UITextFieldDelegate {
    
    var rootRef: FIRDatabaseReference!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headlineTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    var email : String = " "
    var fullName : String = " "
    var headline : String = " "
    var summary : String = " "
    var location : String = " "
    var profilePic : String = " "
    
    override func viewDidLoad() {
        
        self.dismissKeyboardTapped()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = self.rootRef.child("users")
        let idRef = usersRef.child(userID!)
        let listRef = idRef.child("userProfile")
        
        listRef.observe(.value, with: { snapshot in
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
                
                self.emailTextField.text = profileItem.emailSave
                self.nameTextField.text = profileItem.fullNameSave
                self.summaryTextField.text = profileItem.summarySave
                self.headlineTextField.text = profileItem.headlineSave
                self.locationTextField.text = profileItem.locationSave
            }
        })
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        email = emailTextField.text!
        fullName = nameTextField.text!
        location = locationTextField.text!
        headline = headlineTextField.text!
        summary = summaryTextField.text!
        profilePic = " "
        
        let profileItem = ProfileStruct(fullNameNew: fullName, headlineNew: headline, locationNew: location, summaryNew: summary, pictureNew: profilePic, emailNew: email)
            print("profileItem: \(profileItem.fullName)")
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        let usersRef = self.rootRef.child("users")
        
        let idRef = usersRef.child(userID!)
        
        let listRef = idRef.child("userProfile")
        
        listRef.observe(.value, with: { snapshot in
            print(snapshot.childrenCount)
            
            if snapshot.childrenCount == 0 {
                
                let alert = UIAlertController(title: "Create User Profile", message: "Would you like to save this information to your profile?", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    let addChildStr = listRef.childByAutoId()
                    addChildStr.setValue(profileItem.toAnyObject())
                    
                    ProfileStruct.fullNameProf = self.fullName
                    ProfileStruct.headlineProf = self.headline
                    ProfileStruct.locationProf = self.location
                    ProfileStruct.summaryProf = self.summary
                    ProfileStruct.pictureProf = self.profilePic
                    ProfileStruct.emailProf = self.email
                    print(ProfileStruct.emailProf)
                    
                    DispatchQueue.main.async {
                        self.navigationController!.popViewController(animated: true)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                for item in snapshot.children {
                    
                    let alert = UIAlertController(title: "User Profile Exists", message: "Would you like to update this information to your profile?", preferredStyle: .alert)
                    
                    let saveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                        let profileItem = ProfileStruct(snapshot: item as! FIRDataSnapshot)
                        print("profileItem: \(profileItem)")
                        
                        let ref = profileItem.ref
                        print("ref from Profile: \(String(describing: ref))")
                        
                        ref?.updateChildValues(["email": self.email])
                        ref?.updateChildValues(["fullName": self.fullName])
                        ref?.updateChildValues(["headline": self.headline])
                        ref?.updateChildValues(["location": self.location])
                        ref?.updateChildValues(["picture": self.profilePic])
                        ref?.updateChildValues(["summary": self.summary])
                        
                        ProfileStruct.fullNameProf = self.fullName
                        ProfileStruct.headlineProf = self.headline
                        ProfileStruct.locationProf = self.location
                        ProfileStruct.summaryProf = self.summary
                        ProfileStruct.pictureProf = self.profilePic
                        ProfileStruct.emailProf = self.email
                        print(ProfileStruct.emailProf)
                        
                        DispatchQueue.main.async {
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    alert.addAction(saveAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    @IBAction func cancelAction(_ senfer: UIButton) {
        
        //navigationController!.popViewController(animated: true)
        
        DispatchQueue.main.async {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
}
