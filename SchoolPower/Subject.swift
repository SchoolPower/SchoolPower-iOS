//
//  Copyright 2019 SchoolPower Studio
//

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
    var startDate: Date
    var endDate: Date
    
    var assignments: [Assignment] = [Assignment]()
    var grades:[String: Grade] = [String: Grade]()
    
    init(json:JSON) {
        
        let df1 = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        title = json["name"].stringValue
        teacherName = json["teacher"]["firstName"].stringValue + " " + json["teacher"]["lastName"].stringValue
        teacherEmail = json["teacher"]["email"].stringValue
        blockLetter = json["expression"].stringValue
        roomNumber = json["roomName"].stringValue
        startDate = df1.date(from: json["startDate"].stringValue) ?? Date()
        endDate = df1.date(from: json["endDate"].stringValue) ?? Date()
        
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
}
