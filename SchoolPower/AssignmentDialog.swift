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

fileprivate var flags: [(key: String, value: Bool)] = []

class AssignmentDialog: UIView {
    
    class func instanceFromNib(width: CGFloat = 10, subject: String, assignment: Assignment) -> UIView {
        
        let view = UINib(nibName: "AssignmentDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        let theme = ThemeManager.currentTheme()
        
        view.backgroundColor = theme.windowBackgroundColor
        view.bounds.size.width = width
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        flags = assignment.trueFlags
        
        (view.viewWithTag(1) as? UILabel)?.text = assignment.date
        (view.viewWithTag(2) as? UILabel)?.text = assignment.title
        (view.viewWithTag(3) as? UILabel)?.text = assignment.percentage
        (view.viewWithTag(4) as? UILabel)?.text = "score".localize
        (view.viewWithTag(6) as? UILabel)?.text = "weight".localize
        (view.viewWithTag(7) as? UILabel)?.text = assignment.getDividedScore()
        (view.viewWithTag(8) as? UILabel)?.text = assignment.date
        (view.viewWithTag(9) as? UILabel)?.text = assignment.weight
        (view.viewWithTag(10) as? UILabel)?.text = "flags".localize
        
        view.viewWithTag(16)?.backgroundColor = Utils.getColorByLetterGrade(letterGrade: assignment.letterGrade)
        
        (view.viewWithTag(4) as? UILabel)?.textColor = theme.secondaryTextColor
        (view.viewWithTag(6) as? UILabel)?.textColor = theme.secondaryTextColor
        (view.viewWithTag(7) as? UILabel)?.textColor = theme.primaryTextColor
        (view.viewWithTag(9) as? UILabel)?.textColor = theme.primaryTextColor
        (view.viewWithTag(10) as? UILabel)?.textColor = theme.secondaryTextColor
        
        (view.viewWithTag(11) as? UITableView)?.backgroundColor = .clear
        
        
        let scoreCard = view.viewWithTag(12)
        let weightCard = view.viewWithTag(14)
        let flagCard = view.viewWithTag(15)
        scoreCard?.layer.cornerRadius = 5
        scoreCard?.layer.shouldRasterize = true
        scoreCard?.layer.rasterizationScale = UIScreen.main.scale
        scoreCard?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        scoreCard?.layer.shadowRadius = 1
        scoreCard?.layer.shadowOpacity = 0.2
        scoreCard?.layer.backgroundColor = theme.cardBackgroundColor.cgColor
        weightCard?.layer.cornerRadius = 5
        weightCard?.layer.shouldRasterize = true
        weightCard?.layer.rasterizationScale = UIScreen.main.scale
        weightCard?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        weightCard?.layer.shadowRadius = 1
        weightCard?.layer.shadowOpacity = 0.2
        weightCard?.layer.backgroundColor = theme.cardBackgroundColor.cgColor
        flagCard?.layer.cornerRadius = 5
        flagCard?.layer.shouldRasterize = true
        flagCard?.layer.rasterizationScale = UIScreen.main.scale
        flagCard?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        flagCard?.layer.shadowRadius = 1
        flagCard?.layer.shadowOpacity = 0.2
        flagCard?.layer.backgroundColor = theme.cardBackgroundColor.cgColor
        
        return view
    }
}


//MARK: Table View
extension AssignmentDialog: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "AssignmentFlagListItem", bundle: nil), forCellReuseIdentifier: "Cell")
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let (icon, descrip) = Utils.getAssignmentFlagIconAndDescripWithKey(key: flags[indexPath.row].key)
        (tableCell.viewWithTag(1) as! UIImageView).image = icon
        (tableCell.viewWithTag(2) as! UILabel).text = descrip
        (tableCell.viewWithTag(2) as! UILabel).textColor = ThemeManager.currentTheme().primaryTextColor
        tableCell.selectionStyle = .none
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
