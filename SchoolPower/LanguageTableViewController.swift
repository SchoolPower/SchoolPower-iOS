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

class LanguageTableViewController: UITableViewController {
    
    @IBOutlet weak var itemdef: UITableViewCell?
    @IBOutlet weak var itemeng: UITableViewCell?
    @IBOutlet weak var itemchit: UITableViewCell?
    @IBOutlet weak var itemchis: UITableViewCell?
    @IBOutlet weak var itemdefLable: UILabel?
  
    var languageIndex: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        self.title = "language".localize
        languageIndex = userDefaults.integer(forKey: LANGUAGE_KEY_NAME)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemdef, itemeng, itemchit, itemchis]
        for item in itemSet {
            item?.accessoryType = .none
            item?.textLabel?.textColor = ThemeManager.currentTheme().primaryTextColor
            if itemSet.index(where: {$0 === item})! == languageIndex { item?.accessoryType = .checkmark }
        }
        itemdefLable?.text = "default".localize
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        userDefaults.set(indexPath.row, forKey: LANGUAGE_KEY_NAME)
        userDefaults.synchronize()
        let selectedLang = LOCALE_SET[indexPath.row]
        DGLocalization.sharedInstance.setLanguage(withCode: selectedLang)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLanguage"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
