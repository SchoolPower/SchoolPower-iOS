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
    
    let keySets = ["language", "dashboarddisplays"]
    
    @IBOutlet weak var languageTitle: UILabel?
    @IBOutlet weak var dspTitle: UILabel?
    @IBOutlet weak var languageDetail: UILabel?
    @IBOutlet weak var dspDetail: UILabel?
    
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "settings".localize
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        registerDefaults()
        loadDetails()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "display".localize
    }
    
    func registerDefaults(){
        
        if userDefaults.object(forKey: keySets[0]) == nil {
            userDefaults.register(defaults: [keySets[0]: 0])
        }
        if userDefaults.object(forKey: keySets[1]) == nil {
            userDefaults.register(defaults: [keySets[1]: 1])
        }
        userDefaults.synchronize()
    }
    
    func loadDetails() {
        
        let descriptionSets = [["default".localize, "English", "繁體中文", "简体中文"],
                               ["thisterm".localize, "thissemester".localize]]
        
        languageTitle?.text = "language".localize
        dspTitle?.text = "dashboarddisplays".localize
        languageDetail?.text = descriptionSets[0][userDefaults.integer(forKey: keySets[0])]
        dspDetail?.text = descriptionSets[1][userDefaults.integer(forKey: keySets[1])]
    }
}

//MARK: Table View
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
