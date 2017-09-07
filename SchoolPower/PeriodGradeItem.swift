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
