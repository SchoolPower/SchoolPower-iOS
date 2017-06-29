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
    @IBOutlet weak var leftBackground: UIView!

    override func awakeFromNib() {
        
        foreBackground.layer.cornerRadius = 10
        foreBackground.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    var infoItem: MainListItem! {
        didSet {
            let periodGradeItem: PeriodGradeItem? = Utils().getLatestItem(item: infoItem)
            headerTeacherName.text = infoItem.teacherName
            headerBlockLetter.text = "Block " + infoItem.blockLetter
            headerRoomNumber.text = "Room " + infoItem.roomNumber
            headerPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            headerLetterGrade.text = infoItem.getLetterGrade(requiredTerm: periodGradeItem)
            leftBackground.backgroundColor = Utils().getColorByPeriodItem(item: periodGradeItem!)
        }
    }

}
