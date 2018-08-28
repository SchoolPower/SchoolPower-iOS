//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip

class LineChartViewController: UIViewController, IndicatorInfoProvider {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: #imageLiteral(resourceName: "baseline_show_chart_black_24pt").tint(with: .white))
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
        lineChart.isHidden = true
        if Utils.getFilteredSubjects(subjects: subjects).count > 0 &&
            Utils.getGradedSubjects(subjects: subjects).count > 0 {
            do { try initLineChart() }
            catch {
                print("initLineChart: LineChart Initialization failed!")
                lineChart.isHidden = true
                CNALabel.isHidden = false
            }
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
    
    func initLineChart() throws -> Void {
        
        CNALabel.isHidden = true
        lineChart.isHidden = false
        
        let theme = ThemeManager.currentTheme()
        
        // [SubjectName: [Entry<Date, Grade>]]
        let historyData = Utils.readHistoryGrade()
        var organizedData = [String: [ChartDataEntry]]()
        var lastData = [String: ChartDataEntry]()
        let lineData = LineChartData()
        
        for (date, subjectsJson):(String, JSON) in historyData {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let doubleDate = Double(Int(dateFormatter.date(from: date)!.timeIntervalSince1970/60.0/60.0/24.0))
            
            for subjectNow in subjectsJson.arrayValue {
                
                let subjectName = subjectNow["name"].stringValue
                let subjectGrade = subjectNow["grade"].doubleValue
                
                // TODO: Better way to CONTINUE the loop (inside Foreach)
                if !userDefaults.bool(forKey: SHOW_INACTIVE_KEY_NAME) {
                    
                    // Show current cources only
                    var skipThisOne = false
                    let currentTime = Date.init()
                    
                    subjects.indices.forEach ({
                        if subjects[$0].title == subjectName {
                            let it = subjects[$0]
                            if (currentTime < it.startDate || currentTime > it.endDate) {
                                skipThisOne = true
                            }
                        }
                    })
                    if skipThisOne {
                        continue
                    }
                }
                
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
            let color = Colors.materialChartColorList[count]
            dataSet.colors = [color]
            dataSet.circleColors = [color]
            dataSet.circleRadius = 5
            dataSet.circleHoleRadius = 2
            dataSet.valueTextColor = .black
            dataSet.lineWidth = 2.0
            dataSet.mode = .horizontalBezier
            lineData.addDataSet(dataSet)
            dataSet.valueTextColor = Utils.getAccent()
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
        lineChart.legend.form = Legend.Form.circle
        lineChart.legend.textColor = theme.primaryTextColor
        lineChart.legend.wordWrapEnabled = true
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.backgroundColor = theme.cardBackgroundColor
        lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 0.0)
        
    }
}

class LineChartFormatter: NSObject, IAxisValueFormatter{
    
    private let mFormat = DateFormatter()
    
    override init(){
        
        super.init()
        mFormat.dateFormat = "MM/dd"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return mFormat.string(from: Date(timeIntervalSince1970:value*60.0*60.0*24.0))
    }
}
