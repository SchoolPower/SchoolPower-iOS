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
import MaterialComponents

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var languageTitle: UILabel?
    @IBOutlet weak var dspTitle: UILabel?
    @IBOutlet weak var showInactiveTitle: UILabel?
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var languageDetail: UILabel?
    @IBOutlet weak var dspDetail: UILabel?
    
    @IBOutlet weak var showInactiveSwitch: UISwitch!
    @IBOutlet weak var enableNotificationSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    let keySets = ["language", "dashboardDisplays", "showInactive", "enableNotification"]
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "settings".localize
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        registerDefaults()
        loadDetails()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "display".localize
        case 1: return "notification".localize
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "show_inactive_summary".localize
        default: return ""
        }
    }
    
    func registerDefaults(){
        
        if userDefaults.object(forKey: keySets[0]) == nil { userDefaults.register(defaults: [keySets[0]: 0]) }
        if userDefaults.object(forKey: keySets[1]) == nil { userDefaults.register(defaults: [keySets[1]: 1]) }
        if userDefaults.object(forKey: keySets[2]) == nil { userDefaults.register(defaults: [keySets[2]: false]) }
        if userDefaults.object(forKey: keySets[3]) == nil { userDefaults.register(defaults: [keySets[3]: true]) }
        userDefaults.synchronize()
    }
    
    func loadDetails() {
        
        let descriptionSets = [["default".localize, "English", "繁體中文", "简体中文"],
                               ["thisterm".localize, "thissemester".localize]]
        
        languageTitle?.text = "language".localize
        dspTitle?.text = "dashboardDisplays".localize
        showInactiveTitle?.text = "show_inactive_title".localize
        notificationTitle?.text = "enable_notification".localize
        
        languageDetail?.text = descriptionSets[0][userDefaults.integer(forKey: keySets[0])]
        dspDetail?.text = descriptionSets[1][userDefaults.integer(forKey: keySets[1])]
        
        showInactiveSwitch.setOn(userDefaults.bool(forKey: keySets[2]), animated: false)
        enableNotificationSwitch.setOn(userDefaults.bool(forKey: keySets[3]), animated: false)
    }
    
    @IBAction func showInactiveSwichOnChange(_ sender: Any) {
        userDefaults.set(showInactiveSwitch.isOn, forKey: keySets[2])
        userDefaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFilteredSubjects"), object: nil)
    }
    
    @IBAction func enableNotificationSwichOnChange(_ sender: Any) {
        userDefaults.set(enableNotificationSwitch.isOn, forKey: keySets[3])
        userDefaults.synchronize()

    }
    
}

//MARK: Table View
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
