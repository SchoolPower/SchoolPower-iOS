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

class CourseDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerTeacherName: UILabel!
    @IBOutlet weak var headerBlockLetter: UILabel!
    @IBOutlet weak var headerRoomNumber: UILabel!
    @IBOutlet weak var headerPercentageGrade: UILabel!
    @IBOutlet weak var headerLetterGrade: UILabel!
    @IBOutlet weak var foreBackground: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var leftBackground: UIView!
    @IBOutlet weak var assignments: UILabel?

    override func awakeFromNib() {
        
        foreBackground.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        foreBackground.layer.shadowRadius = 2
        foreBackground.layer.shadowOpacity = 0.2
        foreBackground.layer.backgroundColor = UIColor.clear.cgColor
        
        foreground.layer.cornerRadius = 10
        foreground.layer.masksToBounds = true
        
        assignments?.text = "assignments".localize
        super.awakeFromNib()
    }
    
    var infoItem: MainListItem! {
        didSet {
            let periodGradeItem: PeriodGradeItem? = infoItem.getLatestItem()
            headerTeacherName.text = infoItem.teacherName
            headerBlockLetter.text = "Block " + infoItem.blockLetter
            headerRoomNumber.text = "room".localize + infoItem.roomNumber
            headerPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            headerLetterGrade.text = infoItem.getLetterGrade(requiredTerm: periodGradeItem)
            leftBackground.backgroundColor = Utils.getColorByPeriodItem(item: periodGradeItem!)
        }
    }

}
