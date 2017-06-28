//
//  AppDelegate.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-21.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import UIKit
import Material

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let mainController = story.instantiateViewController(withIdentifier: "DashboardNav")
        let leftViewController = story.instantiateViewController(withIdentifier: "Drawer")
        
        window = UIWindow(frame: Screen.bounds)
        window!.rootViewController = AppNavigationDrawerController(rootViewController: mainController, leftViewController: leftViewController, rightViewController: nil)
        window!.makeKeyAndVisible()
    }

}

