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

class CourseDetailTableViewController: UITableViewController {
    
    var infoItem: MainListItem!
    var list: Array<AssignmentItem> = Array()
    var termsList: Array<String> = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = infoItem.subjectTitle
        
        initTermList()
        setAllTerms(termsList: termsList)
        self.navigationController?.navigationBar.barTintColor = Utils().getColorByPeriodItem(item: Utils().getLatestItem(item: infoItem)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        tableView.backgroundColor = Utils().hexStringToUIColor(hex: Colors().foreground_material_dark)
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
    }
    
    private func initTermList() {
        
        let periodGradeItemList = infoItem.periodGradeItemArray
        termsList.append("ALL TERMS")
        for i in periodGradeItemList.indices{ termsList.append(periodGradeItemList[i].termIndicator) }
    }
    
    private func setAllTerms(termsList: Array<String>) {
        
        if termsList.contains("Y1") {setTerm(term: "Y1")}
        else if termsList.contains("S1") {setTerm(term: "S1")}
        else if termsList.contains("S2") {setTerm(term: "S2")}
        else {setTerm(term: termsList[1])}
    }
    
    
    private func setTerm(term: String) {
        list = infoItem.getAssignmentItemArray(term: term)!
    }
}

//MARK: Table View
extension CourseDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailHeaderCell") as! CourseDetailHeaderCell
        headerCell.infoItem = infoItem
        headerCell.backgroundColor = UIColor.clear
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 133
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailFooterCell")
        footerCell?.backgroundColor = UIColor.clear
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (list.isEmpty) {return 0}
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath) as! AssignmentCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as AssignmentCell = cell else { return }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.location = indexPath.row
        cell.list = list
    }
    
}

