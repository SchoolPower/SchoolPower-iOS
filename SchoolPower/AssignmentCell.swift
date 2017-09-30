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

class AssignmentCell: UITableViewCell {
    
    var location: Int = 0
    
    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var assignmentDate: UILabel!
    @IBOutlet weak var assignmentPercentageGrade: UILabel!
    @IBOutlet weak var assignmentDividedGrade: UILabel!
    @IBOutlet weak var gradeBackground: UIView!
    @IBOutlet weak var foreBackground: UIView!
    @IBOutlet weak var foregroundBroader: UIView!
    
    override func awakeFromNib() {
        
        foreBackground.layer.shouldRasterize = true
        foreBackground.layer.rasterizationScale = UIScreen.main.scale
        foreBackground.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        foreBackground.layer.shadowRadius = 1
        foreBackground.layer.shadowOpacity = 0.2
        foreBackground.layer.backgroundColor = UIColor.clear.cgColor
        
        foregroundBroader.layer.cornerRadius = 10
        foregroundBroader.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    var assignments: Array<Assignment>! {
        
        didSet {
            let sortedList = assignments.sorted(by: {$0.date > $1.date})
            let assignmentItem = sortedList[location]
            assignmentTitle.text = assignmentItem.title
            assignmentDate.text = assignmentItem.date
            assignmentPercentageGrade.text = assignmentItem.percentage + "%"
            assignmentDividedGrade.text = assignmentItem.getDividedScore()
            gradeBackground.backgroundColor = Utils.getColorByLetterGrade(letterGrade: assignmentItem.letterGrade)
            
            if assignmentItem.isNew {
                foreBackground.backgroundColor = UIColor(rgb: Colors.accent)
                assignmentTitle.textColor = .white
                assignmentDate.textColor = UIColor(rgb: Int(Colors.white_0_20))
            }else{
                foreBackground.backgroundColor = .clear
                assignmentTitle.textColor = UIColor(rgb: Colors.text_primary_black)
                assignmentDate.textColor = UIColor(rgb: Colors.text_tertiary_black)
            }
        }
    }
}
