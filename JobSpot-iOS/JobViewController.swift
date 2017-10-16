//
//  JobViewController.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/14/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Firebase
import Social
import MessageUI

class JobViewController: UIViewController, WKNavigationDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var webViewOutlet: UIWebView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var markAppliedOutlet: UIButton!
    var rootRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardTapped()
        
        let urlString = DisplayStruct.jobURLGlobal
        let url = URL(string: urlString)
        let request = URLRequest(url: url! as URL)
        
        webViewOutlet.delegate = self as? UIWebViewDelegate
        webViewOutlet.loadRequest(request)
        
        debugPrint("web View : \(DisplayStruct.companyNameGlobal)")
        debugPrint("web View : \(DisplayStruct.datePostedGlobal)")
        debugPrint("web View : \(DisplayStruct.jobCityStateGlobal)")
        debugPrint("web View : \(DisplayStruct.jobIDGlobal)")
        debugPrint("web View : \(DisplayStruct.jobLatGlobal)")
        debugPrint("web View : \(DisplayStruct.jobLngGlobal)")
        debugPrint("web View : \(DisplayStruct.jobTitleGlobal)")
        debugPrint("web View : \(DisplayStruct.jobURLGlobal)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootRef = FIRDatabase.database().reference()
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
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
    
    @IBAction func saveAction(_ sender: UIButton) {
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
    
    @IBAction func appliedAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Applied Options", message: "Do you want to mark this job as applied?", preferredStyle: .alert)
        
        let appliedAction = UIAlertAction(title: "Yes", style: .default) { (action) in
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
            
            //let applyDateGlobal = ""
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm a"
            let convertedDate: String = dateFormatter.string(from: currentDate) //08/10/2016 01:42:22 AM
            
            debugPrint("appliedDate: \(convertedDate)")
            
            let appliedJobItem = SaveJob(companyNameSave: companyNameGlobal, datePostedSave: datePostedGlobal, jobCityStateSave: jobCityStateGlobal, jobIDSave: jobIDGlobal, jobLatSave: jobLatGlobal, jobLngSave: jobLngGlobal, jobTitleSave: jobTitleGlobal, jobURLSave: jobURLGlobal, applyDateSave: convertedDate)
            print("appliedDateItem companyName: \(appliedJobItem)")
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            print("userID: \(String(describing: userID))")
            
            let usersRef = self.rootRef.child("users")
            
            print("usersRef: \(usersRef)")
            
            let idRef = usersRef.child(userID!)
            
            print("ifRef: \(idRef)")
            
            let listRef = idRef.child("appliedjobs")
            
            print("listRef: \(listRef)")
            
            let addChildStr = listRef.child(jobIDGlobal)
            print("addChildStr: \(addChildStr)")
            
            addChildStr.setValue(appliedJobItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(appliedAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Navigation Delegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func showErrorSocialMedia(service: String){
        let alert = UIAlertController(title: "Unable to Share", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
