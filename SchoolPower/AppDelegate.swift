//
//  Copyright 2018 SchoolPower Studio

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
import UserNotifications
import IQKeyboardManagerSwift

let GET_DATA_URL = "https://api.schoolpower.tech/api/2.0/get_data.php"
let REGISTER_URL = "https://api.schoolpower.tech/api/notifications/register.php"
let FORUM_URL = "https://feedback.schoolpower.studio"
let WEBSITE_URL = "https://www.schoolpower.tech"
let CODE_URL = "https://github.com/SchoolPower"
let SUPPORT_EMAIL = "harryyunull@gmail.com"

let TOKEN_KEY_NAME = "apns_token"
let LANGUAGE_KEY_NAME = "language"
let DASHBOARD_DISPLAY_KEY_NAME = "dashboardDisplays"
let SHOW_INACTIVE_KEY_NAME = "showInactive"
let SELECT_SUBJECTS_KEY_NAME = "selectSubjects"
let CALCULATE_RULE_KEY_NAME = "calculateRule"
let ENABLE_NOTIFICATION_KEY_NAME = "enableNotification"
let SHOW_GRADES_KEY_NAME = "showGradesInNotification"
let NOTIFY_UNGRADED_KEY_NAME = "notifyUngraded"
let LOGGED_IN_KEY_NAME = "loggedin"
let USERNAME_KEY_NAME = "username"
let PASSWORD_KEY_NAME = "password"
let STUDENT_NAME_KEY_NAME = "studentname"
let DARK_THEME_KEY_NAME = "darkTheme"
let ACCENT_COLOR_KEY_NAME = "accentColor"

let CUSTOM_RULES = ["all", "highest_3", "highest_4", "highest_5"]

let JSON_FILE_NAME = "dataMap.json"

let LOCALE_SET = [Locale().initWithLanguageCode(languageCode: Bundle.main.preferredLocalizations.first! as NSString,
                                                countryCode: "gb", name: "United Kingdom"),
                  Locale().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom"),
                  Locale().initWithLanguageCode(languageCode: "zh-Hant", countryCode: "cn", name: "China"),
                  Locale().initWithLanguageCode(languageCode: "zh-Hans", countryCode: "cn", name: "China")]

let userDefaults = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        registerUserDefaults()
        IQKeyboardManager.sharedManager().enable = true
        DGLocalization.sharedInstance.startLocalization()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9841217337381410~2237579488")
        registerForPushNotifications(application: application)
        application.applicationIconBadgeNumber = 0
        
        ThemeManager.applyTheme(theme: userDefaults.bool(forKey: DARK_THEME_KEY_NAME) ? .dark : .light)
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        var gotoController: UIViewController
        
        if userDefaults.bool(forKey: LOGGED_IN_KEY_NAME) {
            
            gotoController = story.instantiateViewController(withIdentifier: "DashboardNav")
            gotoController.view.tag = 1
            let leftViewController = story.instantiateViewController(withIdentifier: "Drawer")
            UIApplication.shared.delegate?.window??.rootViewController = AppNavigationDrawerController(rootViewController: gotoController, leftViewController: leftViewController, rightViewController: nil)
            
        } else {
            
            gotoController = story.instantiateViewController(withIdentifier: "login")
            window = UIWindow(frame: Screen.bounds)
            window!.rootViewController = gotoController
        }
        window!.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        if userDefaults.object(forKey: TOKEN_KEY_NAME) == nil {
            
            userDefaults.register(defaults: [TOKEN_KEY_NAME: token])
            userDefaults.synchronize()
            
            Utils.sendNotificationRegistry(token: token)
            
        } else {
            userDefaults.set(token, forKey: TOKEN_KEY_NAME)
        }
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        if userDefaults.object(forKey: TOKEN_KEY_NAME) == nil {
            userDefaults.register(defaults: [TOKEN_KEY_NAME: ""])
            userDefaults.synchronize()
        } else {
            userDefaults.set("", forKey: TOKEN_KEY_NAME)
        }
        print("Failed to register: \(error)")
    }
    func sendNewAssignmentNotification(messageBody: String, assignmentNum : Int){
        
        if #available(iOS 10.0, *) {
            
            let notification = UNMutableNotificationContent()
            notification.sound = UNNotificationSound.default()
            notification.title = "\("attendence_new".localize)"
            notification.body = messageBody
            notification.badge = ((notification.badge?.intValue)! + assignmentNum) as NSNumber
            
            let identifier = "newAssignmentNotification"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                print("Cannot Send Notification")
            })
            
        } else {
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) { notification.alertTitle = "SchoolPower" }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = Date.init(timeIntervalSinceNow: 0)
            notification.applicationIconBadgeNumber += assignmentNum
            notification.alertBody = "\(String(assignmentNum)) \("attendence_new".localize): \(messageBody)"
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    func sendNewAttendanceNotification(messageBody: String, attendanceNum : Int){
        
        if #available(iOS 10.0, *) {
            
            let notification = UNMutableNotificationContent()
            notification.sound = UNNotificationSound.default()
            notification.title = "notification_new".localize
            notification.body = messageBody
            notification.badge = ((notification.badge?.intValue)! + attendanceNum) as NSNumber
            
            let identifier = "newAssignmentNotification"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                print("Cannot Send Notification")
            })
            
        } else {
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) { notification.alertTitle = "SchoolPower" }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = Date.init(timeIntervalSinceNow: 0)
            notification.applicationIconBadgeNumber += attendanceNum
            notification.alertBody = "\("notification_new".localize): \(messageBody)"
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    // Handle silent remote notification and send a local notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if userDefaults.bool(forKey:ENABLE_NOTIFICATION_KEY_NAME)
            && userDefaults.bool(forKey: LOGGED_IN_KEY_NAME)
        {
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
            
            let username = userDefaults.string(forKey: USERNAME_KEY_NAME)
            let password = userDefaults.string(forKey: PASSWORD_KEY_NAME)
            
            if username == nil || username == "" {
                completionHandler(.noData)
                return
            }
            
            //Send Post
            Utils.sendPost(url: GET_DATA_URL,
                           params: "username=\(username!)&password=\(password!)&version=\(version)&os=ios&action=ios_notification")
            { (response) in
                if response.contains("{") {
                    
                    let showGrades = self.userDefaults.bool(forKey: SHOW_GRADES_KEY_NAME)
                    let showUngraded = self.userDefaults.bool(forKey: NOTIFY_UNGRADED_KEY_NAME)
                    
                    var subjects : [Subject]
                    var oldSubjects : [Subject]
                    var attendances : [Attendance]
                    var oldAttendances : [Attendance]
                    
                    (_, attendances, subjects, disabled, disabled_title, disabled_message) = Utils.parseJsonResult(jsonStr: response)
                    (_, oldAttendances, oldSubjects, disabled, disabled_title, disabled_message) = Utils.readDataArrayList()!
                    
                    var updatedSubjects : [String] = []
                    var updatedGradedSubjects : [String] = []
                    // Diff
                    if subjects.count == oldSubjects.count {
                        for i in 0...subjects.count - 1 {
                            
                            let newAssignmentListCollection = subjects[i].assignments
                            let oldAssignmentListCollection = oldSubjects[i].assignments
                            for item in newAssignmentListCollection {
                                
                                var newItem = true
                                var newGrade = true // this does not include the case that grade is unpublished
                                var grade = ""
                                
                                for it in oldAssignmentListCollection {
                                    if it.title == item.title && it.date == item.date {
                                        newItem = false // if there is a item in old data that matches its name, then it is not a new assignment.
                                        if it.score == item.score || it.score == "--"{ // if the score is the same or becoming unpublished, then its grade is not new.
                                            newGrade = false
                                        }
                                        else { // otherwise, the grade is new.
                                            grade = it.score
                                        }
                                    }
                                }
                                if (newItem && item.score != "--") { // if it is new item and have a grade
                                    newGrade = true // the grade is new.
                                    grade = item.score
                                } else if (item.score == "--"){
                                    newGrade = false
                                }
                                // Possible outcome:
                                // newItem == false && newGrade == true: when the item is not new but the grade is new (either being changed or just published). In this case, variable grade will be set.
                                // newItem == false && newGrade == false: when the item and the grade are both not new (either still not published or it is the same grade).
                                // newItem == true && newGrade == true: when a new graded assignment is published.
                                // newItem == true && newGrade == false: when a ungraded assignment is published.
                                
                                if (newGrade || (newItem && showUngraded)) {
                                    if (newGrade && showGrades){
                                        updatedGradedSubjects.append("\(item.title)(\(grade)/\(item.maximumScore))")
                                    }
                                    else{
                                        updatedSubjects.append(item.title)
                                    }
                                }
                            }
                            
                            var updatedAttendances = [String]()
                            
                            for item in attendances {
                                var newItem = true
                                for it in oldAttendances {
                                    if it.subject == item.subject && it.date == item.date && it.code == item.code {
                                        newItem = false
                                    }
                                }
                                if newItem {
                                    updatedAttendances.append(item.subject + " - " + item.description)
                                }
                            }
                            var allSubjects : [String] = updatedSubjects
                            allSubjects.append(contentsOf: updatedGradedSubjects)
                            if allSubjects.count != 0 {
                                self.sendNewAssignmentNotification(messageBody: allSubjects.joined(separator: ","), assignmentNum: allSubjects.count)
                            }
                            if updatedAttendances.count != 0 {
                                self.sendNewAttendanceNotification(messageBody: updatedAttendances.joined(separator: ","), attendanceNum: updatedAttendances.count)
                                completionHandler(.newData)
                            } else {
                                if updatedSubjects.count == 0 && updatedGradedSubjects.count == 0{
                                    completionHandler(.noData)
                                }else{
                                    completionHandler(.newData)
                                }
                            }
                        }
                    } else { completionHandler(.noData) }
                } else { completionHandler(.failed) }
            }
        } else { completionHandler(.noData) }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                
                guard granted else { return }
                //See if the premission is still there
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            
            //For lower than iOS 10.0
            let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
        }
    }
    
    func registerUserDefaults(){
        
        if userDefaults.object(forKey: LANGUAGE_KEY_NAME) == nil { userDefaults.register(defaults: [LANGUAGE_KEY_NAME: 0]) }
        if userDefaults.object(forKey: DASHBOARD_DISPLAY_KEY_NAME) == nil { userDefaults.register(defaults: [DASHBOARD_DISPLAY_KEY_NAME: 1]) }
        if userDefaults.object(forKey: SHOW_INACTIVE_KEY_NAME) == nil { userDefaults.register(defaults: [SHOW_INACTIVE_KEY_NAME: false]) }
        if userDefaults.object(forKey: SELECT_SUBJECTS_KEY_NAME) == nil { userDefaults.register(defaults: [SELECT_SUBJECTS_KEY_NAME: [String]()]) }
        if userDefaults.object(forKey: CALCULATE_RULE_KEY_NAME) == nil { userDefaults.register(defaults: [SHOW_INACTIVE_KEY_NAME: 0]) }
        if userDefaults.object(forKey: ENABLE_NOTIFICATION_KEY_NAME) == nil { userDefaults.register(defaults: [ENABLE_NOTIFICATION_KEY_NAME: true]) }
        if userDefaults.object(forKey: SHOW_GRADES_KEY_NAME) == nil { userDefaults.register(defaults: [SHOW_GRADES_KEY_NAME: true]) }
        if userDefaults.object(forKey: NOTIFY_UNGRADED_KEY_NAME) == nil { userDefaults.register(defaults: [NOTIFY_UNGRADED_KEY_NAME: true]) }
        if userDefaults.object(forKey: LOGGED_IN_KEY_NAME) == nil { userDefaults.register(defaults: [LOGGED_IN_KEY_NAME: false]) }
        if userDefaults.object(forKey: DARK_THEME_KEY_NAME) == nil { userDefaults.register(defaults: [DARK_THEME_KEY_NAME: false]) }
        if userDefaults.object(forKey: ACCENT_COLOR_KEY_NAME) == nil { userDefaults.register(defaults: [ACCENT_COLOR_KEY_NAME: 7]) }
        
        userDefaults.synchronize()
    }
}

