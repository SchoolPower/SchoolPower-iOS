//
//  RadarChartViewController.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/06/21.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip

class RadarChartViewController: UIViewController, IndicatorInfoProvider {
    
    var radarChart: RadarChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        initContainer()
        
        if subjects.count > 0 {
            initRadarChart()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RADAR")
    }
    
    func initContainer() {
        
        containerView?.layer.shouldRasterize = true
        containerView?.layer.rasterizationScale = UIScreen.main.scale
        containerView?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        containerView?.layer.shadowRadius = 1
        containerView?.layer.shadowOpacity = 0.2
        containerView?.backgroundColor = ThemeManager.currentTheme().cardBackgroundColor
        containerView?.layer.cornerRadius = 10
        containerView?.layer.masksToBounds = true
        
        if (containerView?.subviews.count)! > 0 {
            containerView?.subviews[0].removeFromSuperview()
        }
    }
    
    func initRadarChart(){
        
        CNALabel.isHidden = true
        radarChart = RadarChartView()
        
        let theme = ThemeManager.currentTheme()
        var entries = [RadarChartDataEntry]()
        var minGrade = 100.0
        for it in subjects {
            if Utils.getLatestItemGrade(grades: it.grades).letter == "--" {
                continue
            }
            let periodGrade=Double(Utils.getLatestItemGrade(grades: it.grades).percentage)!
            entries.append(RadarChartDataEntry(value: periodGrade))
            if periodGrade<minGrade { minGrade=periodGrade }
        }
        
        let set = RadarChartDataSet(values: entries, label: "Grades")
        let accentColor = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
        set.fillColor = accentColor
        set.colors = [accentColor]
        set.drawFilledEnabled = true
        set.fillAlpha = 0.5
        set.lineWidth = 2.0
        set.drawHighlightCircleEnabled = true
        set.setDrawHighlightIndicators(false)
        
        let radarData = RadarChartData(dataSet: set)
        radarData.setDrawValues(true)
        radarData.setValueTextColor(accentColor)
        radarChart.data = radarData
        
        let xAxis = radarChart.xAxis
        xAxis.yOffset = 10
        xAxis.xOffset = 10
        xAxis.valueFormatter = RadarChartFormatter(data: subjects)
        xAxis.labelTextColor = theme.primaryTextColor
        
        if (xAxis.valueFormatter as! RadarChartFormatter).mSubjectsName.count == 0 {
            return
        }
        
        let yAxis = radarChart.yAxis
        yAxis.axisMinimum = minGrade/3*2
        yAxis.axisMaximum = 110.0 - 10.0
        yAxis.drawLabelsEnabled = false
        radarChart.chartDescription?.enabled=false
        radarChart.legend.enabled=false
        radarChart.translatesAutoresizingMaskIntoConstraints = false
        containerView?.addSubview(radarChart)
        let heightConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -24)
        let widthConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -24)
        let verticalConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        containerView?.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
        
        radarChart.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

class RadarChartFormatter: NSObject, IAxisValueFormatter{
    
    var mSubjectsName = [String]()
    
    init(data: [Subject]){
        for subject in data{
            if Utils.getLatestItemGrade(grades: subject.grades).letter == "--" {
                continue
            }
            mSubjectsName.append(Utils.getShortName(subjectTitle: subject.title))
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        if mSubjectsName.count == 0 {
            return ""
        }
        else {
            return mSubjectsName[Int(value) % mSubjectsName.count]
        }
    }
}
