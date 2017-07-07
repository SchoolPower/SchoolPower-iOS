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

class DashboardDisplaysTableViewController: UITableViewController {

    @IBOutlet weak var itemTermTitle: UILabel?
    @IBOutlet weak var itemSemesterTitle: UILabel?
    @IBOutlet weak var itemTerm: UITableViewCell?
    @IBOutlet weak var itemSemester: UITableViewCell?
    
    let userDefaults = UserDefaults.standard
    let keyName = "dashboarddisplays"
    var dspIndex: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "dashboarddisplays".localize
        dspIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        itemTermTitle?.text = "the_score_of_this_term".localize
        itemSemesterTitle?.text = "the_score_of_this_semester".localize
        
        let itemSet = [itemTerm, itemSemester]
        for item in itemSet {
            item?.accessoryType = .none
            if itemSet.index(where: {$0 === item})! == dspIndex { item?.accessoryType = .checkmark }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        userDefaults.set(indexPath.row, forKey: keyName)
        userDefaults.synchronize()
        
        self.navigationController?.popViewController(animated: true)
    }
}
