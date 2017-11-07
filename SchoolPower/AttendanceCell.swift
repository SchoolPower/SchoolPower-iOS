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

class AttendanceCell: UITableViewCell {
    
    var location: Int = 0
    
    @IBOutlet weak var attendanceCode: UILabel!
    @IBOutlet weak var attendanceDescription: UILabel!
    @IBOutlet weak var attendanceSubject: UILabel!
    @IBOutlet weak var attendanceDate: UILabel!
    @IBOutlet weak var codeBackGround: UIView!
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

    var attendance: Array<Attendance>! {

        didSet {
            let sortedList = attendance.sorted(by: {$0.date > $1.date})
            let attendanceItem = sortedList[location]
            attendanceCode.text = attendanceItem.code
            attendanceDescription.text = attendanceItem.description
            attendanceSubject.text = attendanceItem.subject
            attendanceDate.text = attendanceItem.date
            codeBackGround.backgroundColor = Utils.getColorByAttendanceCode(attendanceCode: attendanceItem.code)
            
            if attendanceItem.isNew {
                foregroundBroader.backgroundColor = UIColor(rgb: Colors.accent)
                attendanceDescription.textColor = .white
                attendanceSubject.textColor = UIColor(rgb: Int(Colors.white_0_20))
                attendanceDate.textColor = UIColor(rgb: Int(Colors.white_0_20))
            } else {
                foregroundBroader.backgroundColor = .white
                attendanceDescription.textColor = UIColor(rgb: Colors.text_primary_black)
                attendanceSubject.textColor = UIColor(rgb: Colors.text_tertiary_black)
                attendanceDate.textColor = UIColor(rgb: Colors.text_tertiary_black)
            }
        }
    }
}

