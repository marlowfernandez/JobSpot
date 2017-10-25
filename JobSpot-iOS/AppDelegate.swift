//
//  AppDelegate.swift
//  JobSpot-iOS
//
//  Created by Krista Appel and Marlow Fernandez on 9/26/17.
//  Copyright © 2017-2018 JobSpot. All rights reserved.
//

import UIKit
import Firebase
import LinkedinSwift
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6204503397505906~5385893242")
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "FFFFFF")
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        UINavigationBar.appearance().barTintColor = UIColor(hex: "CC0000")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: "FFFFFF")]
//        UIBarButtonItem.appearance().titleTextAttributes(for: [NSForegroundColorAttributeName: UIColor.white])
        
        return true
    }
    
//    @nonobjc func application(application: UIApplication,
//                     openURL url: URL,
//                     sourceApplication: String?,
//                     annotation: Any) -> Bool {
//        
//        // Linkedin sdk handle redirect
//        if LinkedinSwiftHelper.shouldHandle(url) {
//            return LinkedinSwiftHelper.application(application,
//                                                   open: url,
//                                                   sourceApplication: sourceApplication,
//                                                   annotation: annotation
//            )
//        }
//        
//        return false
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if LISDKCallbackHandler.shouldHandle(url){
            
            return LISDKCallbackHandler.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: nil)
            
        }
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @nonobjc func application(application: UIApplication,
                     supportedInterfaceOrientationsForWindow window: UIWindow?)
        -> UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return .landscape
            } else {
                return .portrait
            }
    }

}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

