//
//  MainListItem.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-22.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import Foundation

class MainListItem {
    
    var subjectTitle: String
    var teacherName: String
    var blockLetter: String
    var roomNumber: String
    var periodGradeItemArray: Array<PeriodGradeItem>
    
    init( _subjectTitle: String, _teacherName: String, _blockLetter: String,
          _roomNumber: String, _periodGradeItemArray: Array<PeriodGradeItem>) {
        
        subjectTitle = _subjectTitle
        teacherName = _teacherName
        blockLetter = _blockLetter
        roomNumber = _roomNumber
        periodGradeItemArray = _periodGradeItemArray
    }
    
    func getLetterGrade(requiredTerm: PeriodGradeItem?) -> String {
        return periodGradeItemArray[periodGradeItemArray.index(where: {$0 === requiredTerm})!].termLetterGrade
    }
    
    func getPercentageGrade(requiredTerm: PeriodGradeItem?) -> String {
        return periodGradeItemArray[periodGradeItemArray.index(where: {$0 === requiredTerm})!].termPercentageGrade
    }
    
    func getAssignmentItemArray(term: String) -> Array<AssignmentItem>? {
        for item in periodGradeItemArray { if(term == item.termIndicator){ return item.assignmentItemArrayList } }
        return nil
    }
    
    func addPeriodGradeItem(_periodGradeItem: PeriodGradeItem) {
        periodGradeItemArray.append(_periodGradeItem)
    }
}
