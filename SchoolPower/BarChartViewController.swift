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
import Charts
import SwiftyJSON
import XLPagerTabStrip

class BarChartViewController: UIViewController, IndicatorInfoProvider {
    
    var radarChart: BarChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "bar".localize)
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
        if Utils.getFilteredSubjects(subjects: subjects).count > 0 {
//            initBarChart()
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
}
