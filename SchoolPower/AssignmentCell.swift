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
    
    override func awakeFromNib() {
        
        foreBackground.layer.cornerRadius = 10
        foreBackground.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    var list: Array<AssignmentItem>! {
        didSet {

            let sortedList = list.sorted(by: {$0.assignmentDate > $1.assignmentDate})
            let assignmentItem = sortedList[location]
            assignmentTitle.text = assignmentItem.assignmentTitle
            assignmentDate.text = assignmentItem.assignmentDate
            assignmentPercentageGrade.text = assignmentItem.assignmentPercentage
            assignmentDividedGrade.text = assignmentItem.assignmentDividedScore
            gradeBackground.backgroundColor = Utils.getColorByLetterGrade(letterGrade: assignmentItem.assignmentGrade)
            if assignmentItem.isNew {
                foreBackground.backgroundColor = UIColor(rgb: Colors.accent)
                assignmentTitle.textColor = UIColor.white
                assignmentDate.textColor = UIColor(rgb: Colors.white_0_20)
            }else{
                foreBackground.backgroundColor = UIColor.white
                assignmentTitle.textColor = UIColor(rgb: Colors.text_primary_black)
                assignmentDate.textColor = UIColor(rgb: Colors.text_tertiary_black)
            }
        }
    }
}
