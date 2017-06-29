
//  Utils.swift
//  SchoolPower

//  Created by carbonyl on 2017-06-23.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.


import Foundation
import UIKit
import SwiftyJSON

class Utils {
    
    let userDefaults = UserDefaults.standard
    let keyName = "dashboarddisplays"
    
    let gradeColorIds = [Colors().A_score_green, Colors().B_score_green, Colors().Cp_score_yellow, Colors().C_score_orange, Colors().Cm_score_red, Colors().primary_dark, Colors().primary, Colors().primary]
    let gradeColorIdsPlain = [Colors().A_score_green, Colors().B_score_green, Colors().Cp_score_yellow, Colors().C_score_orange, Colors().Cm_score_red, Colors().primary_dark, Colors().primary]
    func indexOfString (searchString: String, domain: Array<String>) -> Int {
        return domain.index(of: searchString)!
    }
    
    /* Color Handler */
    func getColorByLetterGrade(letterGrade: String) -> UIColor {
        return hexStringToUIColor(hex: gradeColorIds[indexOfString(searchString: letterGrade, domain: ["A", "B", "C+", "C", "C-", "F", "I", "--"])])
    }
    
    func getColorByPeriodItem(item: PeriodGradeItem) -> UIColor {
        return getColorByLetterGrade(letterGrade: item.termLetterGrade)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.characters.count) != 6) { return UIColor.gray }
        var rgbletue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbletue)
        
        return UIColor(
            red: CGFloat((rgbletue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbletue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbletue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /* Others */
    func getLatestItem(item: MainListItem) -> PeriodGradeItem? {
        
        var forLatestSemester = false
        var latestTerm: String
        var periodGradeItemList = item.periodGradeItemArray
        var termsList = [String]()
        termsList.append("ALL TERMS")
        
        if userDefaults.integer(forKey: keyName) == 1 { forLatestSemester = true }
        
        for item in periodGradeItemList.indices { termsList.append(periodGradeItemList[item].termIndicator) }
        
        if (forLatestSemester){
            if (termsList.contains("S2")) {latestTerm = "S2"}
            else if (termsList.contains("S1")) {latestTerm = "S1"}
            else if (termsList.contains("T4")) {latestTerm = "T4"}
            else if (termsList.contains("T3")) {latestTerm = "T3"}
            else if (termsList.contains("T2")) {latestTerm = "T2"}
            else {latestTerm = "T1"}}
        else{
            if (termsList.contains("T4")) {latestTerm = "T4"}
            else if (termsList.contains("T3")) {latestTerm = "T3"}
            else if (termsList.contains("T2")) {latestTerm = "T2"}
            else {latestTerm = "T1"}}
        
        for item in periodGradeItemList { if (item.termIndicator == latestTerm) {return item} }
        return nil
    }
    
    func parseJsonResult(jsonStr: String) -> [MainListItem] {
        
        let jsonData = JSON(jsonStr).arrayValue
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
        dataList = dataList.sorted(by: { $0.blockLetter<$1.blockLetter })
        return dataList
    }
}
