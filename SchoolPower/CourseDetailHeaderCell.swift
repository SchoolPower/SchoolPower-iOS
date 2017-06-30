//
//  CourseDetailHeaderCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-24.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import UIKit

class CourseDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerTeacherName: UILabel!
    @IBOutlet weak var headerBlockLetter: UILabel!
    @IBOutlet weak var headerRoomNumber: UILabel!
    @IBOutlet weak var headerPercentageGrade: UILabel!
    @IBOutlet weak var headerLetterGrade: UILabel!
    @IBOutlet weak var foreBackground: UIView!
    @IBOutlet weak var leftBackground: UIView!
    @IBOutlet weak var assignments: UILabel?

    override func awakeFromNib() {
        
        foreBackground.layer.cornerRadius = 10
        foreBackground.layer.masksToBounds = true
        assignments?.text = "assignments".localize
        super.awakeFromNib()
    }
    
    var infoItem: MainListItem! {
        didSet {
            let periodGradeItem: PeriodGradeItem? = Utils().getLatestItem(item: infoItem)
            headerTeacherName.text = infoItem.teacherName
            headerBlockLetter.text = "Block " + infoItem.blockLetter
            headerRoomNumber.text = "room".localize + infoItem.roomNumber
            headerPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            headerLetterGrade.text = infoItem.getLetterGrade(requiredTerm: periodGradeItem)
            leftBackground.backgroundColor = Utils().getColorByPeriodItem(item: periodGradeItem!)
        }
    }

}
