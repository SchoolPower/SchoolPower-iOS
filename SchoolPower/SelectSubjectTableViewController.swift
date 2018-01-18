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

class SelectSubjectsTableViewController: UITableViewController {
    
    var selectedCourceTitles = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "select_subjects".localize
        selectedCourceTitles = userDefaults.array(forKey: SELECT_SUBJECTS_KEY_NAME) as! [String]
    }
}

//MARK: Table View
extension SelectSubjectsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSubjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSubjectsCell", for: indexPath)
        cell.accessoryType = .none
        if selectedCourceTitles.contains(filteredSubjects[indexPath.row].title) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = String.init(format: "(%@%%) %@",
                                           Utils.getLatestItemGrade(grades: filteredSubjects[indexPath.row].grades).percentage,
                                           filteredSubjects[indexPath.row].title)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        cell?.accessoryType = .none
        
        let title = filteredSubjects[indexPath.row].title
        if selectedCourceTitles.contains(title) {
            selectedCourceTitles.remove(at: selectedCourceTitles.index(of: title)!)
        } else {
            selectedCourceTitles.append(title)
            cell?.accessoryType = .checkmark
        }
        
        userDefaults.set(selectedCourceTitles, forKey: SELECT_SUBJECTS_KEY_NAME)
        userDefaults.synchronize()
    }
}
