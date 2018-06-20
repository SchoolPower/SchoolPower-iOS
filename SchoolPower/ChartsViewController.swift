//
//  Copyright 2018 SchoolPower Studio

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
import XLPagerTabStrip
import MaterialComponents.MaterialTabs

class ChartsViewController: ButtonBarPagerTabStripViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    
    var radarChart: RadarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "charts".localize
//        topNALabel.text = "chart_na".localize
//        bottomNALabel.text = "chart_na".localize
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) ,
                style: .plain ,target: self, action: #selector(menuOnClick))
        self.navigationItem.leftBarButtonItems = [menuItem]
        self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        initTabBar()
    }
    
    @objc func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }
    
    override func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            break
        case 1:
            initRadarChart()
            break
        case 2:
            break
        default:
            break
        }
    }
    
    func initTabBar() {

        let theme = ThemeManager.currentTheme()
        let tabBar = MDCTabBar(frame: view.bounds)
        tabBar.items = [
            UITabBarItem(title: "Line", image: nil, tag: 0),
            UITabBarItem(title: "Radar", image: nil, tag: 1),
            UITabBarItem(title: "Bar", image: nil, tag: 2)
        ]
        tabBar.itemAppearance = .titles
        tabBar.sizeToFit()
        tabBar.tintColor = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
        tabBar.barTintColor = theme.primaryColor
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        tabBar.inkColor = UIColor.white.withAlphaComponent(0.1)
        tabBar.selectedItemTintColor = .white
        tabBar.alignment = .justified
        tabBar.setSelectedItem(tabBar.items[0], animated: false)
        tabBar.delegate = self
        
        view.addSubview(tabBar)
    }
    
    
    
    func initRadarChart(){

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
        radarChart.backgroundColor = theme.cardBackgroundColor
        radarChart.layer.cornerRadius = 10
        radarChart.layer.masksToBounds = true

        containerView?.layer.shouldRasterize = true
        containerView?.layer.rasterizationScale = UIScreen.main.scale
        containerView?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        containerView?.layer.shadowRadius = 1
        containerView?.layer.shadowOpacity = 0.2
        containerView?.layer.backgroundColor = UIColor.clear.cgColor

        radarChart.translatesAutoresizingMaskIntoConstraints = false
        containerView?.addSubview(radarChart)
        let heightConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -12)
        let widthConstraint = NSLayoutConstraint(item: radarChart, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: containerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -12)
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


