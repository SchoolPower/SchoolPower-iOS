//
//  LineChartViewController.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/06/16.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class LineChartViewController: UIViewController {
    
    var lineChart: LineChartView!
    
    override func viewDidLoad() {
        if subjects.count != 0 {
            initLineChart()
        }
    }
    
    func initLineChart(){
        
        let historyData = Utils.readHistoryGrade()
        lineChart = LineChartView()
        
        // [SubjectName: [Entry<Date, Grade>]]
        var organizedData = [String: [ChartDataEntry]]()
        var lastData = [String: ChartDataEntry]()
        let lineData = LineChartData()
        
        for (date, subjects):(String, JSON) in historyData {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let doubleDate = Double(Int(dateFormatter.date(from: date)!.timeIntervalSince1970/60.0/60.0/24.0))
            
            for subjectNow in subjects.arrayValue {
                let subjectName = Utils.getShortName(subjectTitle: subjectNow["name"].stringValue)
                let subjectGrade = subjectNow["grade"].doubleValue
                let entry = ChartDataEntry(x: doubleDate, y: subjectGrade)
                
                if organizedData[subjectName]==nil {
                    organizedData[subjectName] = [ChartDataEntry]()
                }
                lastData[subjectName]=entry
                
                let subjectItem = organizedData[subjectName]!
                if subjectItem.count != 0 && abs(subjectGrade-subjectItem.last!.y)<1e-5 {
                    continue
                }
                organizedData[subjectName]!.append(entry)
            }
        }
        for (name, grade) in lastData { organizedData[name]!.append(grade) }
        
        var count = 0
        for (subjectName, value) in organizedData {
            let dataSet = LineChartDataSet(values: value, label: subjectName)
            var colors = [UIColor]()
            for _ in 0...value.count-1 { colors.append(Colors.chartColorList[count]) }
            dataSet.colors = colors
            dataSet.circleColors = colors
            dataSet.circleRadius = 5
            dataSet.circleHoleRadius = 2
            dataSet.valueTextColor = .black
            dataSet.lineWidth = 2.0
            lineData.addDataSet(dataSet)
            count+=1
        }
        
        lineChart.data = lineData
        lineChart.chartDescription?.enabled=false
        
        let xAxis = lineChart.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashLengths = [10, 10, 0]
        xAxis.granularity = 1
        xAxis.valueFormatter = LineChartFormatter()
        lineChart.leftAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.rightAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.legend.form = Legend.Form.line
        lineChart.backgroundColor = .white
        lineChart.layer.cornerRadius = 10
        lineChart.layer.masksToBounds = true
        
//        topHalfView?.layer.shouldRasterize = true
//        topHalfView?.layer.rasterizationScale = UIScreen.main.scale
//        topHalfView?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
//        topHalfView?.layer.shadowRadius = 1
//        topHalfView?.layer.shadowOpacity = 0.2
//        topHalfView?.layer.backgroundColor = UIColor.clear.cgColor
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChart)
//        let heightConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
//        let widthConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        let horizontalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        topHalfView?.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
        
        lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 0.0)
        
    }
    
    
    class LineChartFormatter: NSObject, IAxisValueFormatter{
        
        private let mFormat = DateFormatter()
        
        override init(){
            
            super.init()
            mFormat.dateFormat = "MM/dd"
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String{
            let x=mFormat.string(from: Date(timeIntervalSince1970:value*60.0*60.0*24.0))
            return x
        }
    }
}
