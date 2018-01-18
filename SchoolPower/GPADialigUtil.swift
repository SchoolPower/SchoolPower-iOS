//
//  GPADialigUtil.swift
//  SchoolPower
//
//  Created by Carbonyl on 25/12/2017.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit
import Foundation
import CustomIOSAlertView
import ActionSheetPicker_3_0

class GPADialogUtil {
    
    var view: UIView
    var gpaDialog = UIView()
    var allPeriods = NSMutableSet()
    var currentTerm = 0
    
    var subjectsForGPA: [Subject]
    var GPAOfficial: Double
    
    init() {
        self.view = UIView()
        self.subjectsForGPA = [Subject]()
        self.GPAOfficial = 0.0
    }
    
    init(view: UIView, subjectsForGPA: [Subject], GPAOfficial: Double) {
        self.view = view
        self.subjectsForGPA = subjectsForGPA
        self.GPAOfficial = GPAOfficial
    }
    
    func show () {
        
        var latestPeriods = [String: Grade]()
        
        subjectsForGPA.indices.forEach ({
            let key = Utils.getLatestItem(grades: subjects[$0].grades)
            latestPeriods[key] = subjects[$0].grades[key]
            for keyFilter in subjects[$0].grades.keys {
                if subjects[$0].grades[keyFilter]?.letter != "--" {
                    allPeriods.add(keyFilter)
                }
            }
        })
        
        // overall latest period, usually indicate the current term
        let latestPeriod = Utils.getLatestItem(grades: latestPeriods)
        currentTerm = (allPeriods.allObjects as! [String]).index(of: latestPeriod)!
            
        constructView()
    }
    
    private func customGPANotAvailable() {
        UIAlertView(title: "custom_gpa_not_available".localize,
                    message: "custom_gpa_not_available_because".localize,
                    delegate: nil,
                    cancelButtonTitle: "alright".localize)
            .show()
    }
    
    private func updateData(segmentPos: Int){
        
        let GPAAll = self.calculateGPA(term: self.allPeriods.allObjects[currentTerm] as! String)
        let GPACustom = self.calculateCustomGPA(term: self.allPeriods.allObjects[currentTerm] as! String)
        
        switch segmentPos {
        case 0:
            animateProgressView(value: GPAAll)
            break
        case 1:
            if GPACustom.isNaN {
                customGPANotAvailable()
            } else {
                animateProgressView(value: GPACustom)
            }
            break
        case 2:
            animateProgressView(value: self.GPAOfficial)
            break
        default:
            animateProgressView()
            break
        }
    }
    
    private func constructView() {
        
        let standerdWidth = self.view.frame.width * 0.8
        let alert = CustomIOSAlertView.init()
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: standerdWidth * 1.5))
        
        self.gpaDialog = GPADialog.instanceFromNib(width: standerdWidth)
        let gpaSegments = gpaDialog.viewWithTag(2) as! UISegmentedControl
        let termPullDown = gpaDialog.viewWithTag(5) as! UIButton
        
        gpaSegments.setTitle("all".localize, forSegmentAt: 0)
        gpaSegments.setTitle("custom".localize, forSegmentAt: 1)
        gpaSegments.setTitle("official".localize, forSegmentAt: 2)
        gpaSegments.apportionsSegmentWidthsByContent = true
        gpaSegments.addTarget(self, action: #selector(segmentOnClick), for: .valueChanged)
        termPullDown.addTarget(self, action: #selector(termOnClick), for: .touchUpInside)
        termPullDown.setTitle(self.allPeriods.allObjects[currentTerm] as? String, for: .normal)
        
        percentageLabel?.format = "%.3f%%"
        gpaDialog.center = subview.center
        subview.addSubview(gpaDialog)
        
        alert?.containerView = subview
        alert?.closeOnTouchUpOutside = true
        alert?.buttonTitles = nil
        alert?.show()
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.updateData(segmentPos: 0)
        }
    }
    
    @objc func segmentOnClick() {

        let gpaSegments = gpaDialog.viewWithTag(2) as! UISegmentedControl
        self.updateData(segmentPos: gpaSegments.selectedSegmentIndex)
    }
    
    @objc func termOnClick(sender: UIButton) {
        
        let termPullDown = gpaDialog.viewWithTag(5) as! UIButton
        let gpaSegments = gpaDialog.viewWithTag(2) as! UISegmentedControl
        let picker = ActionSheetStringPicker.init(title: "selectterm".localize, rows: allPeriods.allObjects,
            initialSelection: currentTerm, doneBlock: {
                picker, value, index in
                
                self.currentTerm = value
                self.updateData(segmentPos: gpaSegments.selectedSegmentIndex)
                termPullDown.setTitle(self.allPeriods.allObjects[value] as? String, for: .normal)
                return
                
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
        let cancelButton = UIBarButtonItem()
        let doneButton = UIBarButtonItem()
        cancelButton.title = "cancel".localize
        doneButton.title = "done".localize
        picker?.setCancelButton(cancelButton)
        picker?.setDoneButton(doneButton)
        picker?.show()
    }
    
    private func calculateGPA(term: String) -> Double {
        
        var sum = 0.0
        var num = 0
        for subject in subjects {
            
            let period = subject.grades[term]
            if period == nil || period!.letter == "--" { continue }
            sum += Double(period!.percentage)!
            num += 1
        }
        return sum / Double(num) / 100.0
    }
    
    private func calculateCustomGPA(term : String) -> Double {
        
        let customRule = userDefaults.integer(forKey: CALCULATE_RULE_KEY_NAME)
        let customSubjects = userDefaults.array(forKey: SELECT_SUBJECTS_KEY_NAME) as! [String]
        
        if(customSubjects.isEmpty){
            return Double.nan
        }
        
        var grades = Array<Double>()
        for subject in subjects {
            if let periodGrade = subject.grades[term] {
                if periodGrade.letter == "--" { continue }
                if !customSubjects.contains(subject.title) { continue }
                grades.append(Double.init(periodGrade.percentage)!)
            } else { continue }
        }
        
        if(CUSTOM_RULES[customRule] == "all"){
            return grades.reduce(0, +) / Double.init(grades.count) / 100.0
        } else {
            // MARK: [Jan 18 2018] customRule value represents:
            // 1 -> Hightst 3
            // 2 -> Hightst 4
            // 3 -> Hightst 5
            let highest = grades.sorted(by: >).prefix(customRule + 2)
            return highest.reduce(0, +) / Double.init(highest.count) / 100.0
        }
    }
    
    @objc func animateProgressView(value: Double = 0) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        
        let formerStr = percentageLabel?.text ?? ""
        var strPos: Float = 0
        if formerStr != "" {
            strPos = Float((formerStr.substring(to: formerStr.index(formerStr.endIndex, offsetBy: -1))))!
        }
        
        ring?.ring1.progress = value.isNaN ? 0.0 : value
        ring?.ring1.startColor = Utils.getColorByLetterGrade(
            letterGrade: Utils.getLetterGradeByPercentageGrade(percentageGrade: value * 100))
        ring?.ring1.endColor = (ring?.ring1.startColor)!.lighter(by: 10)!
        
        let duration = formerStr.contains("nan") ? 0.0 : 1.0
        percentageLabel?.countFrom(fromValue: strPos, to: Float(value * 100), withDuration: duration,
                                   andAnimationType: .EaseOut, andCountingType: .Custom)
        
        CATransaction.commit()
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
}
