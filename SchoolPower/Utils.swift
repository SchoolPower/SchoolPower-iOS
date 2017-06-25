//
//  Utils.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-23.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
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
        
        //TODO last semester setting
        let forLatestSemester = false
        var latestTerm: String
        var periodGradeItemList = item.periodGradeItemArray
        var termsList: Array<String> = Array()
        termsList.append("ALL TERMS")
        
        //        if (getSettingsPreference(context.getString(R.string.list_preference_dashboard_display)) == "1") {forLatestSemester = true }
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
    
//    func parseJsonResult(jsonStr: String) -> Array<MainListItem>? {
//        
//        let jsonData = try? JSONSerialization.jsonObject(with: jsonStr, options: [])
//        let dataMap = HashMap<String, MainListItem>()
//        
//        if let jsonData = json
//        
//        for i in 0..jsonData.length() - 1 {
//        
//        let termObj = jsonData.getJSONObject(i)
//        // Turns assignments into an ArrayList
//        let assignmentList = ArrayList<AssignmentItem>()
//        if(!termObj.has("assignments")) continue;
//        let asmArray = termObj.getJSONArray("assignments")
//        for (j in 0..asmArray.length() - 1) {
//        let asmObj = asmArray.getJSONObject(j)
//        let dates = asmObj.getString("date").split("/")
//        let date = dates[2] + "/" + dates[0] + "/" + dates[1]
//        assignmentList.add(AssignmentItem(asmObj.getString("assignment"),
//        date, if (asmObj.getString("grade") == "") "--" else asmObj.getString("percent"),
//        if (asmObj.getString("score").endsWith("d")) context.getString(R.string.unpublished) else asmObj.getString("score"),
//        if (asmObj.getString("grade") == "") "--" else asmObj.getString("grade"), asmObj.getString("category"), termObj.getString("term")))
//        }
//        
//        let periodGradeItem = PeriodGradeItem(termObj.getString("term"),
//        if (termObj.getString("grade") == "") "--" else termObj.getString("grade"), termObj.getString("mark"), assignmentList)
//        
//        // Put the term data into the course data, either already exists or be going to be created.
//        let mainListItem = dataMap[termObj.getString("name")]
//        if (mainListItem == null) { // The course data does not exist yet.
//        
//        let periodGradeList = ArrayList<PeriodGradeItem>()
//        periodGradeList.add(periodGradeItem)
//        
//        dataMap.put(termObj.getString("name"),
//        MainListItem(termObj.getString("name"), termObj.getString("teacher"),
//        termObj.getString("block"), termObj.getString("room"), periodGradeList))
//        
//        } else { // Already exist. Just insert into it.
//        
//        mainListItem.addPeriodGradeItem(periodGradeItem)
//        
//        }
//        }
//        
//        // Convert from HashMap to ArrayList
//        let dataList = ArrayList<MainListItem>()
//        dataList.addAll(dataMap.letues)
//        Collections.sort(dataList, Comparator<MainListItem> { o1, o2 ->
//        if (o1.blockLetter == "HR(1)") return@Comparator -1
//        if (o2.blockLetter == "HR(1)") return@Comparator 1
//        o1.blockLetter.compareTo(o2.blockLetter)
//        })
//        return dataList
//        
//        return nil
//    }
}
