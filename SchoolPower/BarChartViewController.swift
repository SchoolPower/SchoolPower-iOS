//
//  BarChartViewController.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/06/21.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BarChartViewController: UIViewController, IndicatorInfoProvider {
  
    override func viewDidLoad() {
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BAR")
    }
}
