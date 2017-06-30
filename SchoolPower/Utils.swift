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
    
    static let userDefaults = UserDefaults.standard
    static let KEY_NAME = "dashboarddisplays"
    static let JSON_FILE_NAME = "dataMap.json"
    
    static let gradeColorIds = [Colors.A_score_green, Colors.B_score_green, Colors.Cp_score_yellow, Colors.C_score_orange, Colors.Cm_score_red, Colors.primary_dark, Colors.primary, Colors.primary]
    static let gradeColorIdsPlain = [Colors.A_score_green, Colors.B_score_green, Colors.Cp_score_yellow, Colors.C_score_orange, Colors.Cm_score_red, Colors.primary_dark, Colors.primary]
    static func indexOfString (searchString: String, domain: Array<String>) -> Int {
        return domain.index(of: searchString)!
    }
}

//MARK: Color Handler
extension Utils {
    
    static func getColorByLetterGrade(letterGrade: String) -> UIColor {
        return UIColor(rgb: gradeColorIds[indexOfString(searchString: letterGrade, domain: ["A", "B", "C+", "C", "C-", "F", "I", "--"])])
    }
    
    static func getColorByPeriodItem(item: PeriodGradeItem) -> UIColor {
        return getColorByLetterGrade(letterGrade: item.termLetterGrade)
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
    
    static func readFileFromString(filename: String) -> String?{
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { return try String(contentsOf: path, encoding: String.Encoding.utf8) }
            catch { print("Failed to read string from file "+filename) }
        }
        return nil
    }
    
    static func readDataArrayList() -> Array<MainListItem>?{
        return parseJsonResult(jsonStr: readFileFromString(filename: JSON_FILE_NAME)!)
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
}

//MARK: Others
extension Utils {

    static func parseJsonResult(jsonStr: String) -> [MainListItem] {
        
        let jsonData = JSON(data: jsonStr.data(using: .utf8, allowLossyConversion: false)!).arrayValue
        var dataMap = [String : MainListItem]()
        for termObj in jsonData {
            
            // Turns assignments into an ArrayList
            var assignmentList = [AssignmentItem]()
            if let asmArray = termObj["assignments"].array {
                
                for asmObj in asmArray {
                    
                    let dates = asmObj["date"].stringValue.components(separatedBy: "/")
                    let date = dates[2] + "/" + dates[0] + "/" + dates[1]
                    let grade = asmObj["grade"].stringValue
                    assignmentList.append(AssignmentItem(_assignmentTitle: asmObj["assignment"].stringValue, _assignmentDate: date, _assignmentPercentage: grade == "" ? "--" : asmObj["percent"].stringValue, _assignmentDividedScore: asmObj["score"].stringValue.hasSuffix("d") ? "Unpublished":asmObj["score"].stringValue, _assignmentGrade: grade == "" ? "--" :grade, _assignmentCategory: asmObj["category"].stringValue, _assignmentTerm: termObj["term"].stringValue))
                }
                let periodGradeItem = PeriodGradeItem(_termIndicator: termObj["term"].stringValue, _termLetterGrade: termObj["grade"].stringValue == "" ? "--" : termObj["grade"].stringValue, _termPercentageGrade: termObj["mark"].stringValue, _assignmentItemArrayList: assignmentList)
                
                //  Put the term data into the course data, either already exists or will be created
                let name = termObj["name"].stringValue
                if let mainListItem = dataMap[name] {
                    
                    // The course data already exist, just insert into it
                    mainListItem.addPeriodGradeItem(_periodGradeItem: periodGradeItem)
                    
                } else {
                    
                    // The course data is not yet existing
                    dataMap[name] = MainListItem(_subjectTitle: name, _teacherName: termObj["teacher"].stringValue, _blockLetter: termObj["block"].stringValue, _roomNumber: termObj["room"].stringValue, _periodGradeItemArray: [periodGradeItem])
                }
            }
        }
        // Convert HashMap into ArrayList
        var dataList = [MainListItem]()
        for (_, value) in dataMap { dataList.append(value) }
        
        dataList = dataList.sorted(by: { $0.blockLetter < $1.blockLetter })
        return dataList
    }
    
    static func readHistoryGrade() -> JSON {
        let jsonStr = readFileFromString(filename: "history.json") ?? "{}"
        return JSON(data: jsonStr.data(using: .utf8, allowLossyConversion: false)!)
    }
    
    // 1. read data into brief info
    // 2. calculate gpa
    // 3. read history grade from file
    // 4. update history grade
    // 5. save history grade
    static func saveHistoryGrade(data: [MainListItem]){
        // 1. read data into brief info
        var pointSum = 0
        var count = 0
        var gradeInfo: JSON = [] // [{"name":"...","grade":80.0}, ...]
        for subject in data {
            if let leastPeriod = subject.getLatestItem() {
                if !subject.subjectTitle.contains("Homeroom") {
                    pointSum += Int(leastPeriod.termPercentageGrade)!
                    count += 1
                }
                gradeInfo.appendIfArray(json: ["name":subject.subjectTitle,"grade":Double(leastPeriod.termPercentageGrade)!])
            }
        }
    
        // 2. calculate gpa
        gradeInfo.appendIfArray(json: ["name":"GPA","grade":Double(pointSum/count)])
    
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
    
    
    static func getShortName(subjectTitle: String)->String{
        let shorts = ["Homeroom":"HR", "Planning":"PL", "Mandarin":"CN",
            "Chinese":"CSS", "Foundations":"Maths", "Physical":"PE",
            "English":"EN", "Moral":"ME"]
        let short = shorts[subjectTitle.components(separatedBy: " ")[0]]
        if short != nil { return short! }
        
        return subjectTitle
    }
}
