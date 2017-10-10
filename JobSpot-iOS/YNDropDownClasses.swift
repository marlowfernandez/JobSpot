//
//  YNDropDownClasses.swift
//  JobSpot-iOS
//
//  Created by Marlow Fernandez on 10/6/17.
//  Copyright © 2017 JobSpot. All rights reserved.
//

import Foundation
import UIKit
import YNDropDownMenu

class YNFilterView: YNDropDownView {
    @IBOutlet weak var radiusSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var jobDaysSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var sortJobsSegmentOutlet: UISegmentedControl!
    
    struct FilterValues {
        static var radiusString = String()
        static var daysEntered = String()
        static var jobSort = String()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        
        //        self.changeMenu(title: "Changed", at: 1)
        //        self.changeMenu(title: "Changed", status: .selected, at: 0)
        //self.alwaysSelected(at: 1)
        //        self.alwaysSelected(at: 2)
        //        self.alwaysSelected(at: 3)
        self.hideMenu()
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        //self.normalSelected(at: 1)
        self.hideMenu()
    }
    
    override func dropDownViewOpened() {
        print("dropDownViewOpened")
    }
    
    override func dropDownViewClosed() {
        print("dropDownViewClosed")
    }
    
    func initViews() {
    
        
    }
    
    @IBAction func showJobsAction(_ sender: UISegmentedControl) {
        switch radiusSegmentOutlet.selectedSegmentIndex
        {
        case 0:
            debugPrint("10 miles")
            
            FilterValues.radiusString = "10"
            
        case 1:
            debugPrint("20 miles")
            
            FilterValues.radiusString = "20"
            
            break
        case 2:
            debugPrint("30 miles")
            
            FilterValues.radiusString = "30"
            
            break
        case 3:
            debugPrint("40 miles")
            
            FilterValues.radiusString = "40"
            
            break
        default:
            debugPrint("30 miles default")
            
            FilterValues.radiusString = "30"
            
            break
        }
    }
    
    @IBAction func changeDaysAction(_ sender: UISegmentedControl) {
        switch jobDaysSegmentOutlet.selectedSegmentIndex
        {
        case 0:
            debugPrint("7 days")
            
            FilterValues.daysEntered = "7"
            
        case 1:
            debugPrint("14 days")
            
            FilterValues.daysEntered = "14"
            
            break
        case 2:
            debugPrint("30 days")
            
            FilterValues.daysEntered = "30"
            
            break
        default:
            debugPrint("30 days default")
            
            FilterValues.daysEntered = "30"
            
            break
        }
    }
    
    
    @IBAction func sortJobsAction(_ sender: UISegmentedControl) {
        switch sortJobsSegmentOutlet.selectedSegmentIndex
        {
        case 0:
            debugPrint("accquisitiondate")
            
            FilterValues.jobSort = "accquisitiondate"
            
        case 1:
            debugPrint("location")
            
            FilterValues.jobSort = "location"
            
            break
        case 2:
            debugPrint("0")
            
            FilterValues.jobSort = "0"
            
            break
        default:
            debugPrint("accquisitiondate default")
            
            FilterValues.jobSort = "accquisitiondate"
            
            break
        }
        
    }
}


//class YNSavedSearchesView: YNDropDownView {
//    
//    @IBOutlet weak var viewSavedSearchedOutlet: UIButton!
//    let listToProfile = "listToProfile"
//    
//    struct SaveSearchValues {
//        static var selected = String()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
//        self.initViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        self.initViews()
//    }
//    
//    override func dropDownViewOpened() {
//        print("dropDownViewOpened")
//    }
//    
//    override func dropDownViewClosed() {
//        print("dropDownViewClosed")
//    }
//    
//    @IBAction func cancelButtonAction(_ sender: UIButton) {
//        
//        
//        //        self.changeMenu(title: "Changed", at: 1)
//        //        self.changeMenu(title: "Changed", status: .selected, at: 0)
//        self.alwaysSelected(at: 1)
//        //        self.alwaysSelected(at: 2)
//        //        self.alwaysSelected(at: 3)
//        self.hideMenu()
//    }
//    
////    @IBAction func goToSavedSearches(_ sender: UIButton) {
////        if SaveSearchValues.selected == "map" {
////            debugPrint("map is in view, changing view to savedsearched")
////            self.hideMenu()
////            HomeController().mapChangeViewToSavedSearches()
////            
////        } else if SaveSearchValues.selected == "list" {
////            debugPrint("list is in view, changing view to savedsearched")
////            self.hideMenu()
////            ListViewController().listChangeViewToSavedSearches()
////        }
////    }
//    
//    @IBAction func submitButtonAction(_ sender: UIButton) {
//        self.normalSelected(at: 1)
//        self.hideMenu()
//    }
//    
//    func initViews() {
//        
//        
//    }
//}
