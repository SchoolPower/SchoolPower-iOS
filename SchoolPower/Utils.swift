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
import UIKit
import SwiftyJSON

extension JSON{
    
    mutating func appendIfArray(json:JSON){
        
        if var arr = self.array{
            arr.append(json)
            self = JSON(arr);
        }
    }
}

class Utils {
    
    static let gradeColorIds = [
        Colors.A_score_green,
        Colors.B_score_green,
        Colors.Cp_score_yellow,
        Colors.C_score_orange,
        Colors.Cm_score_red,
        Colors.primary_dark,
        Colors.primary,
        Colors.primary
    ]
    
    static let gradeColorIdsPlain = [
        Colors.A_score_green,
        Colors.B_score_green,
        Colors.Cp_score_yellow,
        Colors.C_score_orange,
        Colors.Cm_score_red,
        Colors.primary_dark,
        Colors.primary
    ]
    
    static let attendanceColorIds = [
        Colors.primary_dark,
        Colors.A_score_green,
        Colors.Cp_score_yellow,
        Colors.Cp_score_yellow,
        Colors.C_score_orange,
        Colors.C_score_orange,
        Colors.primary,
        Colors.Cm_score_red,
        Colors.B_score_green,
        Colors.Cm_score_red,
        Colors.B_score_green,
        Colors.A_score_green
    ]
    
    static func indexOfString (searchString: String, domain: Array<String>) -> Int {
        return domain.index(of: searchString)!
    }
}

//MARK: Color Handler
extension Utils {
    
    static func getColorByLetterGrade(letterGrade: String) -> UIColor {
        return UIColor(rgb: gradeColorIds[indexOfString(searchString: letterGrade,
                domain: ["A", "B", "C+", "C", "C-", "F", "I", "--"])])
    }
    
    static func getLetterGradeByPercentageGrade(percentageGrade: Double) -> String {
        
        let letterGrades = ["A", "B", "C+", "C", "C-", "F", "I", "--"]
        if percentageGrade >= 86 { return letterGrades[0] }
        else if percentageGrade >= 73 { return letterGrades[1] }
        else if percentageGrade >= 67 { return letterGrades[2] }
        else if percentageGrade >= 60 { return letterGrades[3] }
        else if percentageGrade >= 50 { return letterGrades[4] }
        else  { return letterGrades[5] }
    }
    
    static func getColorByGrade(item: Grade) -> UIColor {
        return getColorByLetterGrade(letterGrade: item.letter)
    }
    
    static func getColorByAttendanceCode(attendanceCode: String) -> UIColor {
        return UIColor(rgb: attendanceColorIds[indexOfString(searchString: attendanceCode,
                domain: ["A", "E", "L", "R", "H", "T", "S", "I", "X", "M", "C", "D"])])
    }
}

//MARK: I/O
extension Utils {
    
    static func saveStringToFile(filename: String, data: String) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { try data.write(to: path, atomically: false, encoding: String.Encoding.utf8) }
            catch { print("Failed to save string to file "+filename) }
        }
    }
    
    static func readStringFromFile(filename: String) -> String?{
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { return try String(contentsOf: path, encoding: String.Encoding.utf8) }
            catch { print("Failed to read string from file "+filename) }
        }
        return nil
    }
    
    static func readDataArrayList() -> (StudentInformation, [Attendance], [Subject])? {
        return parseJsonResult(jsonStr: readStringFromFile(filename: JSON_FILE_NAME)!)
    }
    
    static func readHistoryGrade() -> JSON {
        let jsonStr = readStringFromFile(filename: "history.json") ?? "{}"
        return JSON(data: jsonStr.data(using: .utf8, allowLossyConversion: false)!)
    }
    
    static func saveHistoryGrade(data: [Subject]?){
        
        if data == nil { saveStringToFile(filename: "history.json", data: "{}") }
        else {
            
            // 1. read data into brief info
            var pointSum = 0
            var count = 0
            var gradeInfo: JSON = [] // [{"name":"...","grade":80.0}, ...]
            for subject in data! {
                let leastPeriod = subject.getLatestItemGrade()
                if leastPeriod.percentage != "--" {
                    if leastPeriod.percentage == "--"{ continue }
                    if !subject.title.contains("Homeroom") {
                        pointSum += Int(leastPeriod.percentage)!
                        count += 1
                    }
                    gradeInfo.appendIfArray(json: ["name":subject.title,"grade":Double(leastPeriod.percentage)!])
                }
            }
            
            // 2. calculate gpa
            if count != 0{
                gradeInfo.appendIfArray(json: ["name":"GPA","grade":Double(pointSum/count)])
            }else{
                gradeInfo.appendIfArray(json: ["name":"GPA","grade":0.0])
            }
            
            // 3. read history grade from file
            var historyData = readHistoryGrade()
            // {"2017-06-20": [{"name":"...","grade":"80"}, ...], ...}
            
            // 4. update history grade
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            historyData[dateFormatter.string(from: Date())] = gradeInfo
            
            // 5. save history grade
            saveStringToFile(filename: "history.json", data: historyData.rawString()!)
        }
    }
}

//MARK: Post
extension Utils {
    
    static func sendPost(url: String, params: String, completion: @escaping (_ retResponse: String) -> ()) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //networking error
                completion("NETWORK_ERROR")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("response = \(String(describing: response))")
            }
            completion(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    static func sendNotificationRegistry(token: String) {
        self.sendPost(url: REGISTER_URL, params: "device_token=\(token)"){ (value) in }
    }
}

//MARK: Others
extension Utils {
    
    static func parseJsonResult(jsonStr: String) ->(StudentInformation, [Attendance], [Subject]) {
        
        let studentData = JSON(data: jsonStr.data(using: .utf8, allowLossyConversion: false)!)
        if (studentData["information"] == JSON.null) { // not successful
            return (StudentInformation(json: "{}"), [Attendance](), [Subject]())
        }
        let studentInfo = StudentInformation(json: studentData["information"])
        var subjects = [Subject]()
        for subject in studentData["sections"].arrayValue { subjects.append(Subject(json: subject)) }
        
        var attendances = [Attendance]()
        for attendance in studentData["attendances"].arrayValue { attendances.append(Attendance(json: attendance)) }
        
        subjects = subjects.sorted {
            if $0.blockLetter == "HR(A-E)" { return true }
            if $1.blockLetter == "HR(A-E)" { return false }
            return $0.blockLetter < $1.blockLetter
        }
        
        return (studentInfo, attendances, subjects)
    }
    
    static func getShortName(subjectTitle: String)->String{
        
        let shorts = ["Homeroom":"HR",
                      "Planning":"PL",
                      "Mandarin":"CN",
                      "Chinese":"CSS",
                      "Foundations":"Maths",
                      "Physical":"PE",
                      "English":"EN",
                      "Moral":"ME",
                      "Information": "IT",
                      "Drama": "DR",
                      "Social":"SS",
                      "Communications":"COMM",
                      "Science":"SC",
                      "Physics":"PHY",
                      "Chemistry":"CHEM",
                      "Pre-Calculus":"PC",
                      "Calculus":"CAL",
                      "Programming":"PROG",
                      "Exercise":"EXE"]
        
        let splited = subjectTitle.components(separatedBy: " ")
        var short = shorts[splited[0]]
        if short != nil {
            if splited[splited.count-1]=="Music" { short! += "M" }
            if splited[splited.count-1]=="Politics" { short! += "P" }
            if splited[splited.count-1]=="Sci" { short! += "S" }
            if splited[splited.count-1]=="Humanities" { short! += "H" }
            if splited[splited.count-1]=="Arts" { short! += "A" }
            return short!
        }
        var ret = ""
        for c in subjectTitle.utf8 {
            if (c > 64 && c < 91) || (c >= 48 && c <= 57) {ret += String(Character(UnicodeScalar(c)))}
        }
        return ret
    }
}
