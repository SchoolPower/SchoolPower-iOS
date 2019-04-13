//
//  Copyright 2019 SchoolPower Studio
//

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
                foregroundBroader.backgroundColor = Utils.getAccent()
                attendanceDescription.textColor = .white
                attendanceSubject.textColor = UIColor(rgb: Int(Colors.white_0_20))
                attendanceDate.textColor = UIColor(rgb: Int(Colors.white_0_20))
            } else {
                
                let theme = ThemeManager.currentTheme()
                foregroundBroader.backgroundColor = theme.cardBackgroundColor
                attendanceDescription.textColor = theme.primaryTextColor
                attendanceSubject.textColor = theme.secondaryTextColor
                attendanceDate.textColor = theme.secondaryTextColor
            }
        }
    }
}

