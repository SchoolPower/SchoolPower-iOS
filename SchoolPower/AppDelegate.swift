//
//  Copyright 2017 SchoolPower Studio

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


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

