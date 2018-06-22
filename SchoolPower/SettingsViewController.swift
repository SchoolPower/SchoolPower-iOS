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
import MessageUI
import MaterialComponents

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var darkThemeTitle: UILabel?
    @IBOutlet weak var accentColorTitle: UILabel?
    
    @IBOutlet weak var languageTitle: UILabel?
    @IBOutlet weak var dspTitle: UILabel?
    @IBOutlet weak var showInactiveTitle: UILabel?
    @IBOutlet weak var selectSubjectsTitle: UILabel?
    @IBOutlet weak var calculateRuleTitle: UILabel?
    
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var showGradesTitle: UILabel!
    @IBOutlet weak var notifyUngeadedTitle: UILabel!
    @IBOutlet weak var reportBugTitle: UILabel!
    @IBOutlet weak var visitForumTitle: UILabel!
    @IBOutlet weak var visitWebsiteTitle: UILabel!
    @IBOutlet weak var getSourceCodeTitle: UILabel!
    
    @IBOutlet weak var languageDetail: UILabel?
    @IBOutlet weak var dspDetail: UILabel?
    @IBOutlet weak var calculateRuleDetail: UILabel?
    @IBOutlet weak var reportBugDetail: UILabel!
    @IBOutlet weak var visitForumDetail: UILabel!
    
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var showInactiveSwitch: UISwitch!
    @IBOutlet weak var enableNotificationSwitch: UISwitch!
    @IBOutlet weak var showGradesSwitch: UISwitch!
    @IBOutlet weak var notifyUngradedSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "settings".localize
        self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadDetails()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "theme".localize
        case 1: return "display".localize
        case 2: return "customize_gpa".localize
        case 3: return "notification_header".localize
        case 4: return "support".localize
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1: return "show_inactive_summary".localize
        default: return ""
        }
    }
    
    func loadDetails() {
        
        let descriptionSets = [["default".localize, "English", "繁體中文", "简体中文"],
                               ["thisterm".localize, "thissemester".localize],
                               ["all".localize, "highest_3".localize, "highest_4".localize, "highest_5".localize]]
        
        let theme = ThemeManager.currentTheme()
        languageTitle?.textColor = theme.primaryTextColor
        dspTitle?.textColor = theme.primaryTextColor
        showInactiveTitle?.textColor = theme.primaryTextColor
        selectSubjectsTitle?.textColor = theme.primaryTextColor
        calculateRuleTitle?.textColor = theme.primaryTextColor
        notificationTitle?.textColor = theme.primaryTextColor
        showGradesTitle?.textColor = theme.primaryTextColor
        notifyUngeadedTitle?.textColor = theme.primaryTextColor
        reportBugTitle?.textColor = theme.primaryTextColor
        visitForumTitle?.textColor = theme.primaryTextColor
        visitWebsiteTitle?.textColor = theme.primaryTextColor
        getSourceCodeTitle?.textColor = theme.primaryTextColor
        darkThemeTitle?.textColor = theme.primaryTextColor
        accentColorTitle?.textColor = theme.primaryTextColor
        
        languageDetail?.textColor = theme.secondaryTextColor
        dspDetail?.textColor = theme.secondaryTextColor
        calculateRuleDetail?.textColor = theme.secondaryTextColor
        reportBugDetail?.textColor = theme.secondaryTextColor
        visitForumDetail?.textColor = theme.secondaryTextColor
        
        
        languageTitle?.text = "language".localize
        dspTitle?.text = "dashboardDisplays".localize
        showInactiveTitle?.text = "show_inactive_title".localize
        selectSubjectsTitle?.text = "select_subjects".localize
        calculateRuleTitle?.text = "calculate_rule".localize
        notificationTitle?.text = "enable_notification".localize
        showGradesTitle?.text = "notification_show_grade".localize
        notifyUngeadedTitle?.text = "notification_show_no_grade_assignment".localize
        reportBugTitle?.text = "report_bug".localize
        visitForumTitle?.text = "feedback_forum".localize
        visitWebsiteTitle?.text = "visit_website".localize
        getSourceCodeTitle?.text = "source_code".localize
        darkThemeTitle?.text = "dark_theme".localize
        accentColorTitle?.text = "accent_color".localize
        
        languageDetail?.text = descriptionSets[0][userDefaults.integer(forKey: LANGUAGE_KEY_NAME)]
        dspDetail?.text = descriptionSets[1][userDefaults.integer(forKey: DASHBOARD_DISPLAY_KEY_NAME)]
        calculateRuleDetail?.text = String.init(format: "%@%@%@",
                                                "calculate_rule_prefix".localize,
                                                descriptionSets[2][userDefaults.integer(forKey: CALCULATE_RULE_KEY_NAME)].lowercased(),
                                                "calculate_rule_suffix".localize)
        reportBugDetail?.text = "report_bug_summary".localize
        visitForumDetail?.text = "feedback_forum_summary".localize
        
        darkThemeSwitch.setOn(userDefaults.bool(forKey: DARK_THEME_KEY_NAME), animated: false)
        
        showInactiveSwitch.setOn(userDefaults.bool(forKey: SHOW_INACTIVE_KEY_NAME), animated: false)
        enableNotificationSwitch.setOn(userDefaults.bool(forKey: ENABLE_NOTIFICATION_KEY_NAME), animated: false)
        showGradesSwitch.setOn(userDefaults.bool(forKey: SHOW_GRADES_KEY_NAME), animated: false)
        notifyUngradedSwitch.setOn(userDefaults.bool(forKey: NOTIFY_UNGRADED_KEY_NAME), animated: false)
    }
    
    @IBAction func darkThemeSwitchOnChange(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0,options: UIViewAnimationOptions.curveEaseOut,animations: {
            ThemeManager.applyTheme(theme: self.darkThemeSwitch.isOn ? .dark : .light)
            self.viewWillAppear(true)
        }, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    @IBAction func showInactiveSwichOnChange(_ sender: Any) {
        userDefaults.set(showInactiveSwitch.isOn, forKey: SHOW_INACTIVE_KEY_NAME)
        userDefaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFilteredSubjects"), object: nil)
    }
    
    @IBAction func enableNotificationSwichOnChange(_ sender: Any) {
        userDefaults.set(enableNotificationSwitch.isOn, forKey: ENABLE_NOTIFICATION_KEY_NAME)
        userDefaults.synchronize()
    }
    
    @IBAction func showGradesSwichOnChange(_ sender: Any) {
        userDefaults.set(showGradesSwitch.isOn, forKey: SHOW_GRADES_KEY_NAME)
        userDefaults.synchronize()
    }
    
    
    @IBAction func notifyUngradedSwichOnChange(_ sender: Any) {
        userDefaults.set(notifyUngradedSwitch.isOn, forKey: NOTIFY_UNGRADED_KEY_NAME)
        userDefaults.synchronize()
    }
}

//MARK: Table View & Email
extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
                break
            case 1:
                UIApplication.shared.openURL(NSURL(string: WEBSITE_URL)! as URL)
                break
            case 2:
                UIApplication.shared.openURL(NSURL(string: CODE_URL)! as URL)
                break
            default:
                break
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([SUPPORT_EMAIL])
        mailComposerVC.setSubject("bug_report_email_subject".localize)
        mailComposerVC.setMessageBody("bug_report_email_content".localize, isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
