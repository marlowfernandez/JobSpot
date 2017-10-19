//
//  NavController.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/18/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            debugPrint("Hello this is an ipad")
            
            // this code will be executed if the device is an iPad
             func supportedInterfaceOrientations() -> Int {
                return UIInterfaceOrientation.landscapeLeft.rawValue
            }
            
            func shouldAutorotate() -> Bool {
                return false
            }
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            debugPrint("Hello this is an iphone")
            
            // this code will be executed if the device is an iPad
             func supportedInterfaceOrientations() -> Int {
                return UIInterfaceOrientation.portrait.rawValue
            }
            
            func shouldAutorotate() -> Bool {
                return false
            }
            
        }
        
    }
    
}
