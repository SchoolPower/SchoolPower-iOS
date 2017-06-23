//
//  PeriodGradeItem.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-22.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import Foundation

class PeriodGradeItem {
    
    var termIndicator: String
    var termLetterGrade: String
    var termPercentageGrade: String
    var assignmentItemArrayList: Array<AssignmentItem>
    
    init( _termIndicator: String, _termLetterGrade: String, _termPercentageGrade: String,
          _assignmentItemArrayList: Array<AssignmentItem>) {
        
        termIndicator = _termIndicator
        termLetterGrade = _termLetterGrade
        termPercentageGrade = _termPercentageGrade
        assignmentItemArrayList = _assignmentItemArrayList
    }
}
