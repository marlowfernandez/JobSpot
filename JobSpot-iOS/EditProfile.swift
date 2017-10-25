//
//  EditProfile.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/22/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class EditProfile: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    var rootRef: FIRDatabaseReference!
    var listRef: FIRDatabaseReference!
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
    @IBOutlet weak var profileImageOutlet: UIImageView!
    @IBOutlet weak var editPhotoOutlet: UIButton!
    var picker = UIImagePickerController()
    let storage = FIRStorage.storage()
    var storageRef = FIRStorageReference()
    var boolCheck : BooleanLiteralType = false
    
    override func viewDidLoad() {
        
        self.dismissKeyboardTapped()
        
        picker = UIImagePickerController()
        picker.delegate = self
        
        cancelButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        saveButtonOutlet.backgroundColor = UIColor(hex: "CC0000")
        
        storageRef = storage.reference()
        rootRef = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = self.rootRef.child("users")
        let idRef = usersRef.child(userID!)
        listRef = idRef.child("userProfile")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        listRef.observe(.value, with: { snapshot in
            if snapshot.childrenCount == 0 {
                self.saveButtonOutlet.setTitle("Save", for: .normal)
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
                    
                    self.fullName = ProfileStruct.fullNameProf
                    self.headline = ProfileStruct.headlineProf
                    self.location = ProfileStruct.locationProf
                    self.summary = ProfileStruct.summaryProf
                    self.profilePic = ProfileStruct.pictureProf
                    self.email = ProfileStruct.emailProf
                    
                    self.emailTextField.text = ProfileStruct.emailProf
                    self.nameTextField.text = ProfileStruct.fullNameProf
                    self.summaryTextField.text = ProfileStruct.summaryProf
                    self.headlineTextField.text = ProfileStruct.headlineProf
                    self.locationTextField.text = ProfileStruct.locationProf
                    
                    let urlPic = URL(string: ProfileStruct.pictureProf)
                    if ProfileStruct.pictureProf.lengthOfBytes(using: String.Encoding.utf8) > 5 {
                        
                        let dataFromPic = try? Data(contentsOf: urlPic!)
                        if dataFromPic != nil {
                            self.profileImageOutlet.image = UIImage(data: dataFromPic!)
                            self.profileImageOutlet.setNeedsDisplay()
                        }
                    }
                    
                    self.saveButtonOutlet.setTitle("Update", for: .normal)
                }
            }
            
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listRef.removeAllObservers()
        
        listRef.observe(.value, with: { snapshot in
            if snapshot.childrenCount == 0 {
                self.saveButtonOutlet.setTitle("Save", for: .normal)
            } else {
                self.saveButtonOutlet.setTitle("Update", for: .normal)
            }
        })
    }
    
    @IBAction func editPhotoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Update Profile Picture", message: "Would you like to upload a new profile picture?", preferredStyle: .alert)
        
        let galleryAction = UIAlertAction(title: "Yes, from Gallery", style: .default) { (action) in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
            self.picker.popoverPresentationController?.sourceView = sender
        }
        
        let cameraAction = UIAlertAction(title: "Yes, from Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
                let alert = UIAlertController(title: "Camera Error", message: "You do not have a camera to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        boolCheck = false
        
        email = emailTextField.text!
        fullName = nameTextField.text!
        location = locationTextField.text!
        headline = headlineTextField.text!
        summary = summaryTextField.text!
        profilePic = ProfileStruct.pictureProf
        
        let profileItem = ProfileStruct(fullNameNew: fullName, headlineNew: headline, locationNew: location, summaryNew: summary, pictureNew: profilePic, emailNew: email)
            print("profileItem: \(profileItem.fullName)")
        
        listRef.observe(.value, with: { snapshot in
            print(snapshot.childrenCount)
            
            if snapshot.childrenCount == 0 {
                
                let alert = UIAlertController(title: "Create User Profile", message: "Would you like to save this information to your profile?", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    let addChildStr = self.listRef.childByAutoId()
                    addChildStr.setValue(profileItem.toAnyObject())
                    
                    ProfileStruct.fullNameProf = profileItem.fullNameSave
                    ProfileStruct.headlineProf = profileItem.headlineSave
                    ProfileStruct.locationProf = profileItem.locationSave
                    ProfileStruct.summaryProf = profileItem.summarySave
                    ProfileStruct.pictureProf = profileItem.pictureSave
                    ProfileStruct.emailProf = profileItem.emailSave
                    
                    DispatchQueue.main.async {
                        self.navigationController!.popViewController(animated: true)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
                self.boolCheck = true
                
            } else if (snapshot.childrenCount > 0) && (self.boolCheck == false) {
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
        DispatchQueue.main.async {
            self.navigationController!.popViewController(animated: true)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImageOutlet.image = image
            let data = UIImageJPEGRepresentation(profileImageOutlet.image!, 0.8)! as NSData
            
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    
                    self.listRef.observe(.value, with: { snapshot in
                        print(snapshot.childrenCount)
                        
                        if snapshot.childrenCount > 0 {
                            for item in snapshot.children {
                                let profileItem = ProfileStruct(snapshot: item as! FIRDataSnapshot)
                                print("profileItem: \(profileItem)")
                                
                                let ref = profileItem.ref
                                print("ref from Profile: \(String(describing: ref))")
                                
                                let downloadURL = metaData?.downloadURL()?.absoluteString
                                
                                ref?.updateChildValues(["picture": downloadURL!])
                                
                                ProfileStruct.pictureProf = downloadURL!
                                
                                debugPrint("PICTUREUPDATE downloadURL: \(ProfileStruct.pictureProf))")
                            }
                        } else {
                                let downloadURL = metaData?.downloadURL()?.absoluteString
                            
                                ProfileStruct.pictureProf = downloadURL!
                        }
                    })

                }
            }
            
            profileImageOutlet.contentMode = .scaleAspectFit
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                profileImageOutlet.image = self.ResizeImage(image: image, changeSizeTo: CGSize(200.0, 200.0))
            } else {
                profileImageOutlet.image = self.ResizeImage(image: image, changeSizeTo: CGSize(150.0, 150.0))
            }
            
            dismiss(animated:true, completion: nil)
        } else{
            print("Image was not able to be returned.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
