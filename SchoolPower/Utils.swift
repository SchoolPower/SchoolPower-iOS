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
}
