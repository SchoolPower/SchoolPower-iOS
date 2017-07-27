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
    
    func getLatestItem(forLatestSemester: Bool = Utils.userDefaults.integer(forKey: Utils.KEY_NAME) == 1) -> PeriodGradeItem? {
        
        var latestTerm: String
        var periodGradeItemList = periodGradeItemArray
        var termsList = [String]()
        termsList.append("ALL TERMS")
        
        for item in periodGradeItemList.indices { termsList.append(periodGradeItemList[item].termIndicator) }
        
        if forLatestSemester{
            if termsList.contains("S2") {latestTerm = "S2"}
            else if termsList.contains("S1") {latestTerm = "S1"}
            else if termsList.contains("T4") {latestTerm = "T4"}
            else if termsList.contains("T3") {latestTerm = "T3"}
            else if termsList.contains("T2") {latestTerm = "T2"}
            else {latestTerm = "T1"}}
        else{ // for latest term
            if termsList.contains("T4") {latestTerm = "T4"}
            else if termsList.contains("T3") {latestTerm = "T3"}
            else if termsList.contains("T2") {latestTerm = "T2"}
            else {latestTerm = "T1"}}
        
        for item in periodGradeItemList { if item.termIndicator == latestTerm {return item} }
        
        return nil
    }
}
