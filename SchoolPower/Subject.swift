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
import SwiftyJSON

/*
 Sample:
 {
 "assignments": [
 (AssignmentItem)...
 ],
 "expression": "1(A-E)",
 "finalGrades": {
 "X1": {
 "percentage": "0.0",
 "letter": "--"
 },
 "T2": {
 "percentage": "0.0",
 "letter": "--"
 },
 "T1": {
 "percentage": "80.0",
 "letter": "B"
 },
 "S1": {
 "percentage": "80.0",
 "letter": "B"
 }
 ,
 "name": "Course Name",
 "roomName": "100",
 "teacher": {
 "firstName": "John",
 "lastName": "Doe",
 "email": null,
 "schoolPhone": null
 }
 }
 */
struct Grade{
    var percentage: String
    var letter: String
    var comment: String
    var evaluation: String
}

class Subject {
    
    var title: String
    var teacherName: String
    var teacherEmail: String
    var blockLetter: String
    var roomNumber: String
    
    var assignments: [Assignment] = [Assignment]()
    var grades:[String: Grade] = [String: Grade]()
    
    init(json:JSON) {
        
        title = json["name"].stringValue
        teacherName = json["teacher"]["firstName"].stringValue + " " + json["teacher"]["lastName"].stringValue
        teacherEmail = json["teacher"]["email"].stringValue
        blockLetter = json["expression"].stringValue
        roomNumber = json["roomName"].stringValue
        
        let jsonAssignments = json["assignments"].arrayValue
        for assignment in jsonAssignments{
            assignments.append(Assignment(json: assignment))
        }
        
        let finalGrades = json["finalGrades"].dictionaryValue
        for (key, grade) in finalGrades{
            grades[key]=Grade(percentage: String(Int(Double(grade["percent"].stringValue)!)),
                              letter: grade["letter"].stringValue,
                              comment: grade["comment"].stringValue,
                              evaluation: grade["eval"].stringValue)
        }
    }
    
    func getLatestItem(forLatestSemester: Bool = userDefaults.integer(forKey: DASHBOARD_DISPLAY_KEY_NAME) == 1) -> String {
        
        var termsList = [String]()
        
        for key in grades.keys { termsList.append(key) }
        
        if forLatestSemester{
            
            if termsList.contains("S2") && grades["S2"]?.letter != "--" {return "S2"}
            else if termsList.contains("S1") && grades["S1"]?.letter != "--" {return "S1"}
            else if termsList.contains("T4") && grades["T4"]?.letter != "--" {return "T4"}
            else if termsList.contains("T3") && grades["T3"]?.letter != "--" {return "T3"}
            else if termsList.contains("T2") && grades["T2"]?.letter != "--" {return "T2"}
            else if termsList.contains("T1") {return "T1"}
            else {return ""}
        }
            
        else{ // for latest term
            
            if termsList.contains("T4") && grades["T4"]?.letter != "--" {return "T4"}
            else if termsList.contains("T3") && grades["T3"]?.letter != "--" {return "T3"}
            else if termsList.contains("T2") && grades["T2"]?.letter != "--" {return "T2"}
            else if termsList.contains("T1") {return "T1"}
            else {return ""}
        }
    }
    
    func getLatestItemGrade(forLatestSemester: Bool = userDefaults.integer(forKey: DASHBOARD_DISPLAY_KEY_NAME) == 1) -> Grade {
        return grades[getLatestItem(forLatestSemester: forLatestSemester)] ?? Grade(percentage: "--", letter: "--", comment: "", evaluation:"--")
    }
}
