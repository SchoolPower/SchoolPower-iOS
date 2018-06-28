//
//  LineChartViewController.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/06/21.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip

class LineChartViewController: UIViewController, IndicatorInfoProvider {
    
    var lineChart: LineChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "LINE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    override func viewDidLoad() {
        loadTheView()
    }
    
    @objc func loadTheView() {
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        CNALabel.textColor = ThemeManager.currentTheme().primaryTextColor
        initContainer()
        if subjects.count > 0 {
            initLineChart()
        }
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
    
    func initLineChart(){
        
        print("wtf[][][][")
        CNALabel.isHidden = true
        let historyData = Utils.readHistoryGrade()
        lineChart = LineChartView()
        
        let theme = ThemeManager.currentTheme()
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
            dataSet.valueTextColor = theme.primaryTextColor
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
        xAxis.labelTextColor = theme.primaryTextColor
        xAxis.valueFormatter = LineChartFormatter()
        lineChart.leftAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.rightAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.leftAxis.labelTextColor = theme.primaryTextColor
        lineChart.rightAxis.labelTextColor = theme.primaryTextColor
        lineChart.legend.form = Legend.Form.line
        lineChart.legend.textColor = theme.primaryTextColor
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        containerView?.addSubview(lineChart)
        let heightConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -24)
        let widthConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -24)
        let verticalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        containerView?.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
        
        lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 0.0)
        
    }
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
