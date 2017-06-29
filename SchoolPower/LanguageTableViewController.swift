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

class LanguageTableViewController: UITableViewController {
    
    @IBOutlet weak var itemdef: UITableViewCell?
    @IBOutlet weak var itemeng: UITableViewCell?
    @IBOutlet weak var itemchi: UITableViewCell?
    
    let userDefaults = UserDefaults.standard
    let keyName = "language"
    var languageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemdef, itemeng, itemchi]
        for item in itemSet {
            item?.accessoryType = .none
            if itemSet.index(where: {$0 === item})! == languageIndex {
                item?.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        userDefaults.set(indexPath.row, forKey: keyName)
        userDefaults.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
}
