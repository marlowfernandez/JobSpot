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

class DisplayJobController: UIViewController {
    
    let displayToHome = "displayToHome"
    let displayToProfile = "displayToHome"
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var jobTitleOutlet: UILabel!
    @IBOutlet weak var jobCityStateOutlet: UILabel!
    @IBOutlet weak var datePostedOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameOutlet.text = DisplayStruct.companyNameGlobal
        jobTitleOutlet.text = DisplayStruct.jobTitleGlobal
        jobCityStateOutlet.text = DisplayStruct.jobCityStateGlobal
        datePostedOutlet.text = DisplayStruct.datePostedGlobal
    }

    @IBAction func saveJobAction(_ sender: UIButton) {
        
    }
    
    @IBAction func goToHomeAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToHome, sender: nil)
    }
    
    @IBAction func goToProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.displayToProfile, sender: nil)
    }
    
}
