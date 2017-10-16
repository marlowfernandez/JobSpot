//
//  DisplayJobController.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/8/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import LinkedinSwift
import Alamofire
import SwiftyJSON
import Social
import MessageUI

class DisplayJobController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let displayToHome = "displayToHome"
    let displayToProfile = "displayToProfile"
    let displayToSavedJobs = "displayToSavedJobs"
    let displayToAppliedJobs = "displayToAppliedJobs"
    let displayToWebView = "displayToWebView"
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var jobTitleOutlet: UILabel!
    @IBOutlet weak var jobCityStateOutlet: UILabel!
    @IBOutlet weak var datePostedOutlet: UILabel!
    var rootRef: FIRDatabaseReference!
    var companyName = " "
    var datePostedGlobal = " "
    var jobCityStateGlobal = " "
    var jobIDGlobal = " "
    var jobLatGlobal:Double = 0
    var jobLngGlobal:Double = 0
    var jobTitleGlobal = " "
    var jobURLGlobal = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        companyNameOutlet.text = DisplayStruct.companyNameGlobal
        jobTitleOutlet.text = DisplayStruct.jobTitleGlobal
        jobCityStateOutlet.text = DisplayStruct.jobCityStateGlobal
        datePostedOutlet.text = DisplayStruct.datePostedGlobal
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
    }

    @IBAction func saveJobAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Save", message: "Are you sure you want to save this job?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let companyNameGlobal = DisplayStruct.companyNameGlobal
            debugPrint("companyName: \(companyNameGlobal)")
            
            let datePostedGlobal = DisplayStruct.datePostedGlobal
            debugPrint("datePostedGlobal \(datePostedGlobal)")
            
            let jobCityStateGlobal = DisplayStruct.jobCityStateGlobal
            debugPrint("jobCityStateGlobal \(jobCityStateGlobal)")
            
            let jobIDGlobal = DisplayStruct.jobIDGlobal
            debugPrint("jobIDGlobal \(jobIDGlobal)")
            
            let jobLatGlobal = DisplayStruct.jobLatGlobal
            debugPrint("jobLatGlobal \(jobLatGlobal)")
            
            let jobLngGlobal = DisplayStruct.jobLngGlobal
            debugPrint("jobLngGlobal \(jobLngGlobal)")
            
            let jobTitleGlobal = DisplayStruct.jobTitleGlobal
            debugPrint("jobTitleGlobal \(jobTitleGlobal)")
            
            let jobURLGlobal = DisplayStruct.jobURLGlobal
            debugPrint("jobURLGlobal \(jobURLGlobal)")
            
            let applyDateGlobal = ""
            
            let saveJobItem = SaveJob(companyNameSave: companyNameGlobal, datePostedSave: datePostedGlobal, jobCityStateSave: jobCityStateGlobal, jobIDSave: jobIDGlobal, jobLatSave: jobLatGlobal, jobLngSave: jobLngGlobal, jobTitleSave: jobTitleGlobal, jobURLSave: jobURLGlobal, applyDateSave: applyDateGlobal)
            print("saveJobItem companyNAme: \(saveJobItem)")
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            print("userID: \(String(describing: userID))")
            
            let usersRef = self.rootRef.child("users")
            
            print("usersRef: \(usersRef)")
            
            let idRef = usersRef.child(userID!)
            
            print("ifRef: \(idRef)")
            
            let listRef = idRef.child("savedjobs")
            
            print("listRef: \(listRef)")
            
            let addChildStr = listRef.child(jobIDGlobal)
            print("addChildStr: \(addChildStr)")
            
            addChildStr.setValue(saveJobItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //NOT USED AT THE MOMENT
    private func saveJobToFireBase(companyName: String, datePosted: String, jobCityState: String, jobID: String, jobLat: Double, jobLng: Double, jobTitle: String, jobURL: String) {
        
        debugPrint("Save Job to FireBase \(companyName)")
        debugPrint("Save Job to FireBase \(datePosted)")
        debugPrint("Save Job to FireBase \(jobCityState)")
        debugPrint("Save Job to FireBase \(jobID)")
        debugPrint("Save Job to FireBase \(jobLat)")
        debugPrint("Save Job to FireBase \(jobLng)")
        debugPrint("Save Job to FireBase \(jobTitle)")
        debugPrint("Save Job to FireBase \(jobURL)")
        
//        let saveJobItem = SaveJob(companyNameSave: companyName, datePostedSave: datePosted, jobCityStateSave: jobCityState, jobIDSave: jobID, jobLatSave: jobLat, jobLngSave: jobLng, jobTitleSave: jobTitle, jobURLSave: jobURL, appleDateSave: " ")
//        print("saveJobItem: \(saveJobItem)")
        
        debugPrint(DisplayStruct.companyNameGlobal)
        debugPrint(DisplayStruct.datePostedGlobal)
        debugPrint(DisplayStruct.jobCityStateGlobal)
        debugPrint(DisplayStruct.jobIDGlobal)
        debugPrint(DisplayStruct.jobLatGlobal)
        debugPrint(DisplayStruct.jobLngGlobal)
        debugPrint(DisplayStruct.jobTitleGlobal)
        debugPrint(DisplayStruct.jobURLGlobal)
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        print("userID: \(String(describing: userID))")
        
        let usersRef = rootRef.child("users")
        
        print("usersRef: \(usersRef)")
        
        let idRef = usersRef.child(userID!)
        
        print("ifRef: \(idRef)")
        
        let listRef = idRef.child("savedjobs")
        
        print("listRef: \(listRef)")
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Share Job", message: "Choose an action below to share this job.", preferredStyle: .actionSheet)
        
        let shareFacebook = UIAlertAction(title: "Share to Facebook", style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
                post.setInitialText("Check out this job! #jobspot - Title: \(DisplayStruct.jobTitleGlobal), Company: \(DisplayStruct.companyNameGlobal), Location: \(DisplayStruct.jobCityStateGlobal), Link: \(DisplayStruct.jobURLGlobal) ")
                
                self.present(post, animated: true, completion: nil)
                
            } else {
                self.showErrorSocialMedia(service: "Facebook")
            }
        }
        
        let shareTwitter = UIAlertAction(title: "Share to Twitter", style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("Check out this job! #jobspot - Title: \(DisplayStruct.jobTitleGlobal), Location: \(DisplayStruct.jobCityStateGlobal), Link: \(DisplayStruct.jobURLGlobal) ")
                
                self.present(post, animated: true, completion: nil)
                
            } else {
                self.showErrorSocialMedia(service: "Twitter")
            }
        }
        
        let shareEmail = UIAlertAction(title: "Share to Email", style: .default) { (action) in
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(shareFacebook)
        alert.addAction(shareTwitter)
        alert.addAction(shareEmail)
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alert, animated: true, completion:  nil)
    }
    
    func showErrorSocialMedia(service: String){
        let alert = UIAlertController(title: "Unable to Share", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func applyViewAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToWebView, sender: nil)
    }
    
    @IBAction func goToHomeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToHome, sender: nil)
    }
    
    @IBAction func goToProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToProfile, sender: nil)
    }
    
    @IBAction func savedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToSavedJobs, sender: nil)
    }
    
    @IBAction func appliedActionButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToAppliedJobs, sender: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Job found in the JobSpot App: \(DisplayStruct.jobTitleGlobal)")
        mailComposerVC.setMessageBody("I've found this job using the JobSpot app. \n Job Title: \(DisplayStruct.jobTitleGlobal) \n Company: \(DisplayStruct.companyNameGlobal) \n Location: \(DisplayStruct.jobCityStateGlobal) \n Job Link: \(DisplayStruct.jobURLGlobal) \n This email is generated by JobSpot.", isHTML: false)
        
        return mailComposerVC
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
