
//
//  Copyright 2019 SchoolPower Studio
//

import UIKit
import Material
import GoogleMobileAds
import UserNotifications

let GET_DATA_URL = "https://api.schoolpower.tech/api/2.0/get_data.php"
let REGISTER_URL = "https://api.schoolpower.tech/api/notifications/register.php"
let FORUM_URL = "https://feedback.schoolpower.studio"
let WEBAPP_URL = "https://web.schoolpower.tech"
let WEBSITE_URL = "https://www.schoolpower.tech"
let CODE_URL = "https://github.com/SchoolPower"
let QQ_GROUP_URL = "https://jq.qq.com/?_wv=1027&k=5mWt9hW"
let SUPPORT_EMAIL = "harryyunull@gmail.com"
let ANDROID_DOWNLOAD_ADDRESS = "https://api.schoolpower.tech/dist/latest.php"
let IOS_DOWNLOAD_ADDRESS = "https://itunes.apple.com/cn/app/schoolpower/id1255370309"
let AVATAR_URL = "https://api.schoolpower.tech/api/2.0/set_avatar.php"
let IMAGE_UPLOAD_URL = "https://sm.ms/api/upload"
let PAYPAL_DONATION_URL = "https://paypal.me/GWang828"
let ILD_URL = "https://files.schoolpower.tech/ild.json"

let BITCOIN_ADDRESS = "1NRdAgeRdapbRe3JQRmNCRfWHR3T664jKf"
let ETHEREUM_ADDRESS = "0x3C170f8dd9A2B28554f8bA034B0fF72FfF92FBa7"

/* TEST ID */
//let ADMOB_APP_ID = "ca-app-pub-3940256099942544/2934735716"
let ADMOB_APP_ID = "ca-app-pub-9841217337381410~2237579488"

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
let LAST_TIME_DONATION_SHOWED_KEY_NAME = "lastTimeDonateShowed"
let IM_COMING_FOR_DONATION_KEY_NAME = "ImComingForDonation"
let USER_AVATAR_KEY_NAME = "userAvatar"
let STUDENT_DOB_KEY_NAME = "studentDOB"
let DONATED_KEY_NAME = "donated"
let LOCAL_ILD_KEY_NAME = "localILD"
let DISPLAYED_ILD_KEY_NAME = "displayedILD"


let CUSTOM_RULES = ["all", "highest_3", "highest_4", "highest_5"]

let JSON_FILE_NAME = "dataMap.json"

let LOCALE_SET = [
    Locale().initWithLanguageCode(languageCode: Bundle.main.preferredLocalizations.first! as NSString, countryCode: "gb", name: "United Kingdom"),
    Locale().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom"),
    Locale().initWithLanguageCode(languageCode: "zh-Hant", countryCode: "cn", name: "China"),
    Locale().initWithLanguageCode(languageCode: "zh-Hans", countryCode: "cn", name: "China"),
    Locale().initWithLanguageCode(languageCode: "ja", countryCode: "jp", name: "Japan")
]

enum SHORT_CUTS {
    case none
    case gpa
    case chart
    case attendance
}

var ON_SHORTCUT: SHORT_CUTS = .none

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let userDefaults = UserDefaults.standard
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        registerUserDefaults()
        DGLocalization.sharedInstance.startLocalization()
        GADMobileAds.configure(withApplicationID: ADMOB_APP_ID)
        registerForPushNotifications(application: application)
        application.applicationIconBadgeNumber = 0
        
        ThemeManager.applyTheme(theme: userDefaults.bool(forKey: DARK_THEME_KEY_NAME) ? .dark : .light)
        
        if #available(iOS 9.0, *) {
            reInitShortcuts()
        }
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        var gotoController: UIViewController
        
        if userDefaults.bool(forKey: LOGGED_IN_KEY_NAME) {
            
            gotoController = story.instantiateViewController(withIdentifier: "DashboardNav")
            gotoController.view.tag = 1
            let leftViewController = story.instantiateViewController(withIdentifier: "Drawer")
            UIApplication.shared.delegate?.window??.rootViewController =
                AppNavigationDrawerController(
                    rootViewController: gotoController,
                    leftViewController: leftViewController,
                    rightViewController: nil)
            
        } else {
            
            gotoController = story.instantiateViewController(withIdentifier: "login")
            window = UIWindow(frame: Screen.bounds)
            window!.rootViewController = gotoController
        }
        window!.makeKeyAndVisible()
    }
    
    @available(iOS 9.0, *)
    func reInitShortcuts() {
        UIApplication.shared.shortcutItems?.removeAll()
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(
            type: "GPA",
            localizedTitle: "GPA".localize,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "ic_grade_white"),
            userInfo: nil))
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(
            type: "CHART",
            localizedTitle: "charts".localize,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "ic_insert_chart_white"),
            userInfo: nil))
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(
            type: "ATTENDANCE",
            localizedTitle: "attendance".localize,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "ic_beenhere_white"),
            userInfo: nil))
    }
    
    @available(iOS 9.0, *)
    func application(_
        application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortCut(item: shortcutItem))
    }
    
    @available(iOS 9.0, *)
    func handleShortCut(item: UIApplicationShortcutItem) -> Bool {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        var gotoController: UIViewController
        
        if userDefaults.bool(forKey: LOGGED_IN_KEY_NAME) {
            
            guard let type = item.type as String? else { return false }
            
            switch type {
            case "GPA":
                ON_SHORTCUT = .gpa
                break
            case "CHART":
                ON_SHORTCUT = .chart
                break
            case "ATTENDANCE":
                ON_SHORTCUT = .attendance
                break
            default:
                ON_SHORTCUT = .none
                return false
            }
            
            gotoController = story.instantiateViewController(withIdentifier: "DashboardNav")
            gotoController.view.tag = 1
            let leftViewController = story.instantiateViewController(withIdentifier: "Drawer")
            UIApplication.shared.delegate?.window??.rootViewController =
                AppNavigationDrawerController(
                    rootViewController: gotoController,
                    leftViewController: leftViewController,
                    rightViewController: nil)
            
        } else {
            
            gotoController = story.instantiateViewController(withIdentifier: "login")
            window = UIWindow(frame: Screen.bounds)
            window!.rootViewController = gotoController
        }
        
        window!.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        if userDefaults.object(forKey: TOKEN_KEY_NAME) == nil {
            
            userDefaults.register(defaults: [TOKEN_KEY_NAME: token])
            
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
            
        } else {
            userDefaults.set("", forKey: TOKEN_KEY_NAME)
        }
        print("Failed to register: \(error)")
    }
    
    func sendNewAssignmentNotification(messageBody: String, assignmentNum : Int){
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "\(String(assignmentNum)) \("notification_new".localize)"
            content.body = messageBody
            content.sound = UNNotificationSound.default()
            content.badge = ((content.badge?.intValue) ?? 0 + assignmentNum) as NSNumber
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) { notification.alertTitle = "SchoolPower" }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = Date.init(timeIntervalSinceNow: 1)
            notification.applicationIconBadgeNumber += assignmentNum
            notification.alertBody = "\(String(assignmentNum)) \("notification_new".localize): \(messageBody)"
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    func sendNewAttendanceNotification(messageBody: String, attendanceNum : Int){
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "\(String(attendanceNum)) \("attendance_new".localize)"
            content.body = messageBody
            content.sound = UNNotificationSound.default()
            content.badge = ((content.badge?.intValue) ?? 0 + attendanceNum) as NSNumber
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) { notification.alertTitle = "SchoolPower" }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = Date.init(timeIntervalSinceNow: 0)
            notification.applicationIconBadgeNumber += attendanceNum
            notification.alertBody = "\(String(attendanceNum)) \("attendance_new".localize): \(messageBody)"
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    // Handle silent remote notification and send a local notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        silentUpdateAndPushLocalNptification(completionHandler: completionHandler)
    }
    
    func silentUpdateAndPushLocalNptification(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if userDefaults.bool(forKey:ENABLE_NOTIFICATION_KEY_NAME)
            && userDefaults.bool(forKey: LOGGED_IN_KEY_NAME) {
            
            let username = userDefaults.string(forKey: USERNAME_KEY_NAME)
            let password = userDefaults.string(forKey: PASSWORD_KEY_NAME)
            
            if username == nil || username == "" {
                completionHandler(.noData)
                return
            }
            
            //Send Post
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
            Utils.sendPost(
                url: GET_DATA_URL,
                params: "username=\(username!)" +
                    "&password=\(password!)" +
                    "&version=\(version)" +
                    "&os=ios" +
            "&action=manual_get_data") { (value) in
                
                let response = value
                if response.contains("{") {
                    
                    let showGrades = self.userDefaults.bool(forKey: SHOW_GRADES_KEY_NAME)
                    let showUngraded = self.userDefaults.bool(forKey: NOTIFY_UNGRADED_KEY_NAME)
                    
                    var subjects : [Subject]
                    var oldSubjects : [Subject]
                    var attendances : [Attendance]
                    var oldAttendances : [Attendance]
                    
                    (_, attendances, subjects, disabled, disabled_title, disabled_message, _) = Utils.parseJsonResult(jsonStr: response)
                    (_, oldAttendances, oldSubjects, disabled, disabled_title, disabled_message, _) = Utils.readDataArrayList()!
                    
                    var updatedSubjects : [String] = []
                    var updatedGradedSubjects : [String] = []
                    
                    // Diff
                    if subjects.count == oldSubjects.count && !subjects.isEmpty {
                        for i in 0...subjects.count - 1 {
                            
                            let newAssignmentListCollection = subjects[i].assignments
                            let oldAssignmentListCollection = oldSubjects[i].assignments
                            for item in newAssignmentListCollection {
                                
                                var newItem = true
                                var newGrade = true // this does not include the case that grade is unpublished
                                var grade = ""
                                
                                for it in oldAssignmentListCollection {
                                    if it.title == item.title && it.date == item.date {
                                        // if an old item that matches its name, then it is old.
                                        newItem = false
                                        if it.score == item.score || it.score == "--"{
                                            // if the score is the same or becoming unpublished,
                                            // then old item with old grade
                                            // (ABS not showing).
                                            newGrade = false
                                        }
                                        else {
                                            // otherwise, old item with new grade
                                            // (ABS showing)
                                            grade = it.score
                                        }
                                    }
                                }
                                if (newItem && item.score != "--") {
                                    // graded new item
                                    // (ABS showing)
                                    grade = item.score
                                } else if (item.score == "--"){
                                    // ungraded new item
                                    // (shown if showUngraded toggled)
                                    newGrade = false
                                }
                                
                                if (newGrade || (newItem && showUngraded)) {
                                    if (newGrade && showGrades){
                                        updatedGradedSubjects.append("\(item.title)(\(item.score)/\(item.maximumScore))")
                                    }
                                    else {
                                        updatedSubjects.append(item.title)
                                    }
                                }
                            }
                        }
                    }
                    
                    var updatedAttendances = [String]()
                    
                    for item in attendances {
                        var newItem = true
                        for it in oldAttendances {
                            if it.subject == item.subject && it.period == item.period
                                && it.date == item.date && !it.isNew {
                                // this attendance ain't new
                                newItem = false
                                break
                            }
                        }
                        if newItem {
                            updatedAttendances.append(item.subject + " - " + item.description)
                        }
                    }
                    var allSubjects : [String] = updatedSubjects
                    allSubjects.append(contentsOf: updatedGradedSubjects)
                    
                    var updated = false
                    
                    if allSubjects.count != 0 {
                        updated = true
                        self.sendNewAssignmentNotification(messageBody: allSubjects.joined(separator: ", "), assignmentNum: allSubjects.count)
                        completionHandler(.newData)
                    }
                    if updatedAttendances.count != 0 {
                        updated = true
                        self.sendNewAttendanceNotification(messageBody: updatedAttendances.joined(separator: ", "), attendanceNum: updatedAttendances.count)
                        completionHandler(.newData)
                    }
                    if(!updated){
                        if allSubjects.count == 0 {
                            completionHandler(.noData)
                        }else{
                            completionHandler(.newData)
                        }
                    }
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
        if userDefaults.object(forKey: SHOW_INACTIVE_KEY_NAME) == nil { userDefaults.register(defaults: [SHOW_INACTIVE_KEY_NAME: true]) }
        if userDefaults.object(forKey: SELECT_SUBJECTS_KEY_NAME) == nil { userDefaults.register(defaults: [SELECT_SUBJECTS_KEY_NAME: [String]()]) }
        if userDefaults.object(forKey: CALCULATE_RULE_KEY_NAME) == nil { userDefaults.register(defaults: [CALCULATE_RULE_KEY_NAME: 0]) }
        if userDefaults.object(forKey: ENABLE_NOTIFICATION_KEY_NAME) == nil { userDefaults.register(defaults: [ENABLE_NOTIFICATION_KEY_NAME: true]) }
        if userDefaults.object(forKey: SHOW_GRADES_KEY_NAME) == nil { userDefaults.register(defaults: [SHOW_GRADES_KEY_NAME: true]) }
        if userDefaults.object(forKey: NOTIFY_UNGRADED_KEY_NAME) == nil { userDefaults.register(defaults: [NOTIFY_UNGRADED_KEY_NAME: true]) }
        if userDefaults.object(forKey: LOGGED_IN_KEY_NAME) == nil { userDefaults.register(defaults: [LOGGED_IN_KEY_NAME: false]) }
        if userDefaults.object(forKey: DARK_THEME_KEY_NAME) == nil { userDefaults.register(defaults: [DARK_THEME_KEY_NAME: false]) }
        if userDefaults.object(forKey: ACCENT_COLOR_KEY_NAME) == nil { userDefaults.register(defaults: [ACCENT_COLOR_KEY_NAME: -1]) }
        if userDefaults.object(forKey: LAST_TIME_DONATION_SHOWED_KEY_NAME) == nil { userDefaults.register(defaults: [LAST_TIME_DONATION_SHOWED_KEY_NAME: ""]) }
        if userDefaults.object(forKey: IM_COMING_FOR_DONATION_KEY_NAME) == nil { userDefaults.register(defaults: [IM_COMING_FOR_DONATION_KEY_NAME: false]) }
        if userDefaults.object(forKey: USER_AVATAR_KEY_NAME) == nil { userDefaults.register(defaults: [USER_AVATAR_KEY_NAME: ""]) }
        if userDefaults.object(forKey: STUDENT_DOB_KEY_NAME) == nil { userDefaults.register(defaults: [STUDENT_DOB_KEY_NAME: ""]) }
        if userDefaults.object(forKey: DONATED_KEY_NAME) == nil { userDefaults.register(defaults: [DONATED_KEY_NAME: false]) }
        if userDefaults.object(forKey: LOCAL_ILD_KEY_NAME) == nil { userDefaults.register(defaults: [LOCAL_ILD_KEY_NAME: ""]) }
        if userDefaults.object(forKey: DISPLAYED_ILD_KEY_NAME) == nil { userDefaults.register(defaults: [DISPLAYED_ILD_KEY_NAME: [String]()]) }
    }
}

