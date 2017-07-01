//
//  Copyright 2017 SchoolPower Studio

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import UIKit
import Material
import Charts
import SwiftyJSON

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var topHalfView: UIView?
    @IBOutlet weak var buttomHalfView: UIView?
    
    var lineChart: LineChartView!
    var radarChart: RadarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "charts".localize
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) , style: .plain ,target: self, action: #selector(menuOnClick))
        self.navigationItem.leftBarButtonItems = [menuItem]
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(rgb: Colors.foreground_material_dark)
        initLineChart()
        initRadarChart()
    }
    
    func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
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
            let doubleDate = Double(Int(dateFormatter.date(from: date)!.timeIntervalSince1970 / 1000.0 / 60.0 / 60.0 / 24.0))
            for subjectNow in subjects.arrayValue {
                let subjectName = Utils.getShortName(subjectTitle: subjectNow["name"].stringValue)
                let subjectGrade = subjectNow["grade"].doubleValue
                let entry = ChartDataEntry(x: doubleDate, y: subjectGrade)
                if organizedData[subjectName]==nil {
                    organizedData[subjectName] = [ChartDataEntry]()
                }
                lastData[subjectName]=entry
                var subjectItem = organizedData[subjectName]!
                if subjectItem.count != 0 && abs(subjectGrade-subjectItem.last!.y)<1e-5 {
                    continue
                }
                subjectItem.append(entry)
            }
        }
        for (name, grade) in lastData {
            organizedData[name]!.append(grade)
        }
        
        var count = 0
        for (subjectName, value) in organizedData {
            let dataSet = LineChartDataSet(values: value, label: subjectName)
            var colors = [UIColor]()
            for _ in 0...value.count-1 { colors.append(Colors.chartColorList[count]) }
            dataSet.colors = colors
            dataSet.circleColors = colors
            dataSet.valueTextColor = UIColor.black
            dataSet.lineWidth = 2.0
            lineData.addDataSet(dataSet)
            count+=1
        }
        
        lineChart.data = lineData
        
        let xAxis = lineChart.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashLengths = [10, 10, 0]
        xAxis.granularity = 1
        xAxis.valueFormatter = LineChartFormatter()
        lineChart.leftAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.rightAxis.gridLineDashLengths = [10, 10, 0]
        lineChart.legend.form = Legend.Form.line
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        topHalfView?.addSubview(lineChart)
        let heightConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: topHalfView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        topHalfView?.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
    }
    
    func initRadarChart(){
        
        radarChart = RadarChartView()
        var entries = [RadarChartDataEntry]()
        let xAxis = radarChart.xAxis
        xAxis.yOffset = 10
        xAxis.xOffset = 10
        xAxis.valueFormatter = RadarChartFormatter(data: dataList)
        
        var minGrade=100.0
        for it in dataList {
            let periodGrade=Double(it.getLatestItem()!.termPercentageGrade)!
            entries.append(RadarChartDataEntry(value: periodGrade))
            if periodGrade<minGrade { minGrade=periodGrade }
        }
        
        let yAxis = radarChart.yAxis
        yAxis.axisMinimum = minGrade/3*2
        yAxis.axisMaximum = 110.0 - 20.0
        yAxis.drawLabelsEnabled = false
        
        let set = RadarChartDataSet(values: entries, label: "Grades")
        set.fillColor = UIColor(rgb: 0x345995)
        set.drawFilledEnabled = true
        set.fillAlpha = 180
        set.lineWidth = 2.0
        set.drawHighlightCircleEnabled = true
        set.setDrawHighlightIndicators(false)
        
        let radarData = RadarChartData(dataSet: set)
        radarData.setDrawValues(true)
        radarData.setValueTextColor(UIColor(rgb: Colors.primary))
        radarChart.legend.enabled=false
        radarChart.data = radarData
        
        radarChart.translatesAutoresizingMaskIntoConstraints = false
        buttomHalfView?.addSubview(radarChart)
        let heightConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: buttomHalfView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: buttomHalfView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttomHalfView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttomHalfView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        buttomHalfView?.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
        
        radarChart.animate(xAxisDuration: 1000)
    }
}

class LineChartFormatter: NSObject, IAxisValueFormatter{
    
    private let mFormat = DateFormatter()
    
    override init(){
        super.init()
        mFormat.dateFormat = "MM/dd"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        return mFormat.string(from: Date(timeIntervalSince1970:value * 1000.0 * 60.0 * 60.0 * 24.0))
    }
}

class RadarChartFormatter: NSObject, IAxisValueFormatter{
    
    private var mSubjectsName = [String]()
    
    init(data: [MainListItem]){
        for subject in data{
            mSubjectsName.append(subject.subjectTitle)
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        return mSubjectsName[Int(value) % mSubjectsName.count]
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


