//
//  AssignmentCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-24.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

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
            gradeBackground.backgroundColor = Utils().getColorByLetterGrade(letterGrade: assignmentItem.assignmentGrade)
            if (assignmentItem.isNew) {
                foreBackground.backgroundColor = Utils().hexStringToUIColor(hex: Colors().accent)
                assignmentTitle.textColor = UIColor.white
                assignmentDate.textColor = Utils().hexStringToUIColor(hex: Colors().white_0_20)
            }else{
                foreBackground.backgroundColor = UIColor.white
                assignmentTitle.textColor = Utils().hexStringToUIColor(hex: Colors().text_primary_black)
                assignmentDate.textColor = Utils().hexStringToUIColor(hex: Colors().text_tertiary_black)
            }
        }
    }
}
