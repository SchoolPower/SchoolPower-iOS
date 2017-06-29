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
