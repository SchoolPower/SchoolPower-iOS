//
//  BarChartViewController.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/06/21.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import XLPagerTabStrip

class BarChartViewController: UIViewController, IndicatorInfoProvider {
    
    var radarChart: BarChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var CNALabel: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BAR")
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
