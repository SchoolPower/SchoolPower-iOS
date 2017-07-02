//
//  AppDelegate.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-21.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import UIKit
import Material
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    let KEY_NAME = "loggedin"

    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        DGLocalization.sharedInstance.startLocalization()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9841217337381410~2237579488")
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        var gotoController: UIViewController
        if userDefaults.object(forKey: KEY_NAME) == nil {
            
            userDefaults.register(defaults: [KEY_NAME: false])
            userDefaults.synchronize()
        }
        if userDefaults.bool(forKey: KEY_NAME) {
            
            gotoController = story.instantiateViewController(withIdentifier: "DashboardNav")
            let leftViewController = story.instantiateViewController(withIdentifier: "Drawer")
            UIApplication.shared.delegate?.window??.rootViewController = AppNavigationDrawerController(rootViewController: gotoController, leftViewController: leftViewController, rightViewController: nil)
        } else {
            
            gotoController = story.instantiateViewController(withIdentifier: "login")
            window = UIWindow(frame: Screen.bounds)
            window!.rootViewController = gotoController
        }
        window!.makeKeyAndVisible()
    }
}

