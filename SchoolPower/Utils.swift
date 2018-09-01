//
//  Copyright 2018 SchoolPower Studio
//

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
        "A" : Colors.primary_dark,
        "E" : Colors.A_score_green_dark,
        "L" : Colors.Cp_score_yellow,
        "R" : Colors.Cp_score_yellow_dark,
        "H" : Colors.C_score_orange_dark,
        "T" : Colors.C_score_orange,
        "S" : Colors.primary,
        "I" : Colors.Cm_score_red,
        "X" : Colors.A_score_green,
        "M" : Colors.Cm_score_red_dark,
        "C" : Colors.B_score_green_dark,
        "D" : Colors.B_score_green,
        "P" : Colors.A_score_green,
        "NR" : Colors.C_score_orange,
        "TW" : Colors.primary,
        "RA" : Colors.Cp_score_yellow_darker,
        "NE" : Colors.Cp_score_yellow_light,
        "U" : Colors.Cp_score_yellow_lighter,
        "RS" : Colors.primary_light,
        "ISS" : Colors.primary,
        "FT" : Colors.B_score_green_dark
    ]
    
    static let citizenshipCode = [
        "M" : "Meeting Expectations",
        "P" : "Partially Meeting Expectations",
        "N" : "Not Yet Meeting Expectations"
    ]
    
    static func indexOfString (searchString: String, domain: Array<String>) -> Int {
        if domain.index(of: searchString) != nil {
            return domain.index(of: searchString)!
        } else {
            // return the "--" color if the letter grade is not found
            return domain.index(of: "--")!
        }
    }
}

//MARK: Color Handler
extension Utils {
    
    static func getAccent() -> UIColor {
        
        var accent = userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)
        if accent == -1 {
            // Initialize with Cyan
            accent = Colors.getCyanPosInAccent()
        }
        return Colors.accentColors[accent]
    }
    
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
        return UIColor(rgb: attendanceColorIds[attendanceCode] ?? Colors.gray)
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
    
    static func readDataArrayList() -> (StudentInformation, [Attendance], [Subject], Bool, String, String, ExtraInfo)? {
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
                let leastPeriod = getLatestItemGrade(grades: subject.grades)
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
    
    static func sendGet(url: String, params: String, completion: @escaping (_ retResponse: String) -> ()) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
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
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    static func getAssignmentFlagIconAndDescripWithKey(key: String) -> (UIImage, String) {
        
        var icon = UIImage()
        var descrip = ""
        
        switch key {
        case "collected":
            icon = #imageLiteral(resourceName: "ic_check_box_white")
            descrip = "collected".localize
            break
        case "late":
            icon = #imageLiteral(resourceName: "ic_late_white")
            descrip = "late".localize
            break
        case "missing":
            icon = #imageLiteral(resourceName: "ic_missing_white")
            descrip = "missing".localize
            break
        case "exempt":
            icon = #imageLiteral(resourceName: "ic_exempt_white")
            descrip = "exempt".localize
            break
        case "excludeInFinalGrade":
            icon = #imageLiteral(resourceName: "ic_exclude_white")
            descrip = "include_in_final_grade".localize
            break
        default:
            icon = #imageLiteral(resourceName: "ic_info")
            descrip = "unknown_flag".localize
            break
        }
        return (icon, descrip)
    }
    
    static func getAllPeriods(subject: [Subject]) -> NSMutableSet {
        
        let allPeriods = NSMutableSet()
        
        subject.indices.forEach ({
            for keyFilter in subjects[$0].grades.keys {
                if subjects[$0].grades[keyFilter]?.letter != "--" {
                    allPeriods.add(keyFilter)
                }
            }
        })
        return allPeriods
    }
    
    static func getLatestPeriod(subject: [Subject]) -> String {
        
        var latestPeriods = [String: Grade]()
        
        subject.indices.forEach ({
            let key = self.getLatestItem(grades: subjects[$0].grades)
            latestPeriods[key] = subjects[$0].grades[key]
        })
        
        // overall latest period, usually indicates the current term
        return Utils.getLatestItem(grades: latestPeriods)
    }
    
    static func sortTerm(terms: [String]) -> [String] {
        var sortableTerms = [SortableTerm]()
        for term in terms {
            sortableTerms.append(SortableTerm(raw: term))
        }
        let sortedTerms = sortableTerms.sorted(by: { $0.value < $1.value })
        var result = [String]()
        for term in sortedTerms {
            result.append(term.raw)
        }
        return result
    }
    
    static func sortTerm(terms: NSMutableSet) -> [String] {
        var sortableTerms = [SortableTerm]()
        for term in terms {
            sortableTerms.append(SortableTerm(raw: term as! String))
        }
        let sortedTerms = sortableTerms.sorted(by: { $0.value < $1.value })
        var result = [String]()
        for term in sortedTerms {
            result.append(term.raw)
        }
        return result
    }
    
    static func getLatestItem(grades: [String: Grade]) -> String {
        
        let forLatestSemester: Bool = userDefaults.integer(forKey: DASHBOARD_DISPLAY_KEY_NAME) == 1
        var termsList = [String]()
        
        for key in grades.keys { termsList.append(key) }
        
        if forLatestSemester{
            
            if termsList.contains("S2") && grades["S2"]?.letter != "--" {return "S2"}
            else if termsList.contains("S1") && grades["S1"]?.letter != "--" {return "S1"}
            else if termsList.contains("T4") && grades["T4"]?.letter != "--" {return "T4"}
            else if termsList.contains("T3") && grades["T3"]?.letter != "--" {return "T3"}
            else if termsList.contains("T2") && grades["T2"]?.letter != "--" {return "T2"}
            else if termsList.contains("T1") {return "T1"}
            else if termsList.contains("Q4") && grades["Q4"]?.letter != "--" {return "Q4"}
            else if termsList.contains("Q3") && grades["Q3"]?.letter != "--" {return "Q3"}
            else if termsList.contains("Q2") && grades["Q2"]?.letter != "--" {return "Q2"}
            else if termsList.contains("Q1") {return "Q1"}
        }
            
        else{ // for latest term
            
            if termsList.contains("T4") && grades["T4"]?.letter != "--" {return "T4"}
            else if termsList.contains("T3") && grades["T3"]?.letter != "--" {return "T3"}
            else if termsList.contains("T2") && grades["T2"]?.letter != "--" {return "T2"}
            else if termsList.contains("T1") {return "T1"}
            else if termsList.contains("Q4") && grades["Q4"]?.letter != "--" {return "Q4"}
            else if termsList.contains("Q3") && grades["Q3"]?.letter != "--" {return "Q3"}
            else if termsList.contains("Q2") && grades["Q2"]?.letter != "--" {return "Q2"}
            else if termsList.contains("Q1") {return "Q1"}
        }
        
        if termsList.contains("Y1") && grades["Y1"]?.letter != "--" {return "Y1"}
        
        return ""
    }
    
    static func getLatestItemGrade(grades: [String: Grade]) -> Grade {
        return grades[getLatestItem(grades: grades)] ?? Grade(percentage: "--", letter: "--", comment: "", evaluation:"--")
    }
    
    static func getGradedSubjects(subjects: Array<Subject>) -> Array<Subject> {
        var gradedSubjects = [Subject]() // Subjects that have grades
        for subject in getFilteredSubjects(subjects: subjects) {
            
            let grade = subject.grades[Utils.getLatestItem(grades: subject.grades)]
            if grade != nil && grade?.letter != "--" {
                gradedSubjects.append(subject)
            }
        }
        return gradedSubjects
    }
    
    static func getFilteredSubjects(subjects: Array<Subject>) -> Array<Subject> {
        var filteredSubjects: Array<Subject>
        if (!userDefaults.bool(forKey: SHOW_INACTIVE_KEY_NAME)) {
            
            filteredSubjects = Array()
            let currentTime = Date.init()
            
            subjects.forEach ({
                if (currentTime > $0.startDate && currentTime < $0.endDate) {
                    filteredSubjects.append($0)
                }
            })
            
        } else {
            filteredSubjects = subjects
        }
        
        return filteredSubjects
    }
    
    static func parseJsonResult(jsonStr: String) ->(
        StudentInformation, [Attendance], [Subject],
        Bool, String, String, ExtraInfo) {
            
            let studentData = JSON(data: jsonStr.data(using: .utf8, allowLossyConversion: false)!)
            if (studentData["information"] == JSON.null) { // not successful
                return (StudentInformation(json: "{}"), [Attendance](), [Subject](),
                        false, "", "", ExtraInfo(avatar: ""))
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
            
            let disabled = studentData["disabled"] != JSON.null
            var disabled_title = ""
            var disabled_message = ""
            
            if (disabled) {
                let disableInfo = studentData["disabled"]
                disabled_title = disableInfo["title"].stringValue
                disabled_message = disableInfo["message"].stringValue
            }
            
            let extraInfo: ExtraInfo
            if studentData["additional"] != JSON.null {
                let additional = studentData["additional"]
                extraInfo = ExtraInfo(avatar: additional["avatar"].stringValue)
            } else {
                extraInfo = ExtraInfo(avatar: "")
            }
            
            return (studentInfo, attendances, subjects,
                    disabled, disabled_title, disabled_message, extraInfo)
    }
    
    static func isBirthDay() -> Bool {
        
        let dobStr = userDefaults.string(forKey: STUDENT_DOB_KEY_NAME) ?? ""
        if dobStr == "" { return false }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dob = df.date(from: dobStr)!
        let now = Date()
        
        if (isLeapYear()) {
            if (isSameDayAndMonth(date1: dob, month: 2, day: 29)) {
                return isSameDayAndMonth(date1: now, month: 3, day: 1)
            }
        }
        return isSameDayAndMonth(date1: now, date2: dob)
    }
    
    static func isSameDayAndMonth(date1: Date, date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.month, .day], from: date1)
        let components2 = Calendar.current.dateComponents([.month, .day], from: date2)
        return components1.month == components2.month && components1.day == components2.day
    }
    
    static func isSameDayAndMonth(date1: Date, month: Int, day: Int) -> Bool {
        let components1 = Calendar.current.dateComponents([.month, .day], from: date1)
        return components1.month == month && components1.day == day
    }
    
    static func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        return isLeapYear
    }
    
    static func isLeapYear(_ date: Date = Date()) -> Bool {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        return isLeapYear(year!)
    }
    
    static func getAge(withSuffix: Bool) -> String {
        
        let dobStr = userDefaults.string(forKey: STUDENT_DOB_KEY_NAME) ?? ""
        if dobStr == "" { return "" }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dob = df.date(from: dobStr)!
        
        let now = Date()
        df.dateFormat = "YYYY"
        let age = Int(df.string(from: now))! - Int(df.string(from: dob))!
        
        if withSuffix {
            return String(age) + getSuffixForNumber(num: age)
        } else {
            return String(age)
        }
    }

    static func getSuffixForNumber(num: Int) -> String {
        switch (num % 10) {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
        }
    }
    
    static func getShortName(subjectTitle: String)->String{
        
        let shorts = [
            "Homeroom":"HR",
            "Morning": "MR",//MARK: Morning Reading
            "Planning":"PL",
            "Mandarin":"CN",
            "Chinese Social Studies":"CSS",
            "Foundations":"MATH",
            "Physical":"PE",
            "English":"ENG",
            "Moral":"ME",
            "Information": "IT",
            "Drama": "DR",
            "Social":"SS",
            "Communications":"COMM",
            "Science":"SCI",
            "Physics":"PHY",
            "Chemistry":"CHEM",
            "Biology": "BIO",//MARK: 生物
            "History": "HIS",//MARK: History 历史
            "Pre-Calculus":"PCAL",
            "Calculus":"CAL",
            "Programming":"PROG",
            "Computer Science": "CS",//MARK: Computer Science 计算机科学
            "Economics": "ECO",//MARK: Economics 经济学
            "Marketing": "MAR",//MARK: Marketing 市场营销
            "Journalism": "JOU",//MARK: Journalism 新闻学
            "Comparative": "CC",//MARK: Comparative Civilizations 文化比较
            "Graduation": "GT",//MARK: Graduation Transfer 毕业转移
            "Exercise":"EX"//MARK: Exercise Break 间操
        ]
        
        var ret = ""
        
        //Use Abbr
        for (full, short) in shorts{
            if subjectTitle.range(of: full) != nil { ret = short }
        }
        
        //AP Suffix
        if subjectTitle.range(of: "AP") != nil { ret += "AP" }
        
        //CSS Suffixes
        if ret == "CSS", subjectTitle.range(of: "Music") != nil { ret += "M" }
        if ret == "CSS", subjectTitle.range(of: "Politics") != nil { ret += "P" }
        if ret == "CSS", subjectTitle.range(of: "Sci") != nil { ret += "S" }
        if ret == "CSS", subjectTitle.range(of: "Humanities") != nil { ret += "H" }
        if ret == "CSS", subjectTitle.range(of: "Arts") != nil { ret += "A" }
        
        if (ret == "") {
            for c in subjectTitle.utf8 {
                if (c > 64 && c < 91) || (c >= 48 && c <= 57) {ret += String(Character(UnicodeScalar(c)))}
            }
        }
        return ret
    }
    
    class ExtraInfo {
        var avatar: String
        init(avatar: String) {
            self.avatar = avatar
        }
    }
}


extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue - percentage / 100,
                                saturation: saturation + percentage / 100,
                                brightness: brightness + percentage / 100,
                                alpha: alpha)
        } else {
            return nil
        }
    }
    
    func adjustHue(by value: CGFloat = 0.0) -> UIColor? {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue + value / 360,
                                saturation: saturation,
                                brightness: brightness,
                                alpha: alpha)
        } else {
            return nil
        }
    }
}

extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self as Date) == self.compare(date2 as Date)
    }
}
