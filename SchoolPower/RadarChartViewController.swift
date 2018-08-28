//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip

class RadarChartViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var radarChart: RadarChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: #imageLiteral(resourceName: "baseline_radar_chart_black_24pt").tint(with: .white))
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
        radarChart.isHidden = true
        if Utils.getFilteredSubjects(subjects: subjects).count > 0 &&
            Utils.getGradedSubjects(subjects: subjects).count > 0 {
            initRadarChart()
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
    
    func initRadarChart(){
        let theme = ThemeManager.currentTheme()
        
        CNALabel.isHidden = true
        radarChart.isHidden = false
        radarChart.backgroundColor = theme.cardBackgroundColor
        
        var gradedSubjects = Utils.getGradedSubjects(subjects: subjects)
        var entries = [RadarChartDataEntry]()
        var minGrade = 100.0
        
        for it in Utils.getFilteredSubjects(subjects: subjects) {
            
            if Utils.getLatestItemGrade(grades: it.grades).letter == "--" {
                continue
            }
            let periodGrade=Double(Utils.getLatestItemGrade(grades: it.grades).percentage)!
            entries.append(RadarChartDataEntry(value: periodGrade))
            if periodGrade<minGrade { minGrade=periodGrade }
        }
        
        let set = RadarChartDataSet(values: entries, label: "Grades")
        let accentColor = Utils.getAccent()
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
        radarChart.backgroundColor = theme.cardBackgroundColor
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
