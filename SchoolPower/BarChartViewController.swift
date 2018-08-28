//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip
import MaterialComponents

class BarChartViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: #imageLiteral(resourceName: "baseline_bar_chart_black_24pt").tint(with: .white))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    override func viewDidLoad() {
        loadTheView()
    }
    
    @objc func loadTheView() {
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        CNALabel.textColor = ThemeManager.currentTheme().secondaryTextColor
        CNALabel.text = "chart_not_available".localize
        initContainer()
        barChart.isHidden = true
        if Utils.getFilteredSubjects(subjects: subjects).count > 0 &&
            Utils.getGradedSubjects(subjects: subjects).count > 0 {
            initBarChart()
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
    }
    
    func initBarChart() {
        
        let theme = ThemeManager.currentTheme()
        
        CNALabel.isHidden = true
        barChart.isHidden = false
        barChart.backgroundColor = theme.cardBackgroundColor
        
        barChart.chartDescription?.enabled = false
        
        let gradedSubjects = Utils.getGradedSubjects(subjects: subjects)
        var dataSets = [BarChartDataSet]()
        var subjectStrings = [String]()
        
        let termStrings = ["T1","T2","T3","T4"]
        let accent = Utils.getAccent()
        let termColors = [
            accent.adjustHue(by: -30),
            accent.adjustHue(by: -10),
            accent.adjustHue(by: 10),
            accent.adjustHue(by: 30)
        ]
        
        // second run -- group them in terms
        var count = 0
        for term in termStrings {
            var group = [ChartDataEntry]()
            
            for subject in gradedSubjects {
                subjectStrings.append(subject.title)
                if subject.grades[term] != nil && subject.grades[term]!.percentage != "0" {
                    group.append(BarChartDataEntry(x: Double(subjectStrings.count - 1),
                                                   y: Double(subject.grades[term]!.percentage)!))
                }else{
                    group.append(BarChartDataEntry(x: Double(subjectStrings.count - 1), y: Double.nan))
                }
            }
            
            let dataSet = BarChartDataSet(values: group, label: term)
            dataSet.colors = [termColors[count]] as! [NSUIColor]
            dataSets.append(dataSet)
            count+=1
        }
        
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.granularity = 4.0
        barChart.xAxis.axisMinimum = 0.0
        barChart.xAxis.axisMaximum = Double(4 * gradedSubjects.count)
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.valueFormatter = BarChartFormatter(subjectStrings: subjectStrings)
        barChart.xAxis.gridColor = theme.secondaryTextColor
        barChart.xAxis.axisLineColor = theme.primaryTextColor
        barChart.xAxis.labelTextColor = theme.primaryTextColor
        barChart.leftAxis.axisLineColor = theme.primaryTextColor
        barChart.leftAxis.labelTextColor = theme.primaryTextColor
        barChart.rightAxis.axisLineColor = theme.primaryTextColor
        barChart.rightAxis.labelTextColor = theme.primaryTextColor
        
        let barData = BarChartData(dataSets: dataSets)
        barData.setDrawValues(true)
        barData.setValueTextColor(Utils.getAccent())
        
        barChart.legend.textColor = theme.primaryTextColor
        barChart.legend.horizontalAlignment = .center
        barChart.data = barData
        barChart.groupBars(fromX: 0.0, groupSpace: 0.2, barSpace: 0.1)
        barChart.setVisibleXRange(minXRange: 0.0, maxXRange: 12.0)
        barChart.setScaleEnabled(true)
        barChart.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    private let mFormat = DateFormatter()
    private var mSubjectStrings: [String]
    init(subjectStrings: [String]){
        mFormat.dateFormat = "MM/dd"
        mSubjectStrings = subjectStrings
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let index = Int(value/4)
        if index < 0 || index >= mSubjectStrings.count { return "" }
        return mSubjectStrings[index]
    }
}

