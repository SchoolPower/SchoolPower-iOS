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
import XLPagerTabStrip

class ChartsViewController: ButtonBarPagerTabStripViewController {
    
    fileprivate var firstLoaded = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "charts".localize
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) ,
                style: .plain ,target: self, action: #selector(menuOnClick))
        self.navigationItem.leftBarButtonItems = [menuItem]
        self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        reloadViewFromNib()
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        self.reloadPagerTabStripView()
    }
    
    override func viewDidLoad() {
        
        initTabBar()
        super.viewDidLoad()
    }
    
    @objc func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }
    
    func initTabBar() {

        let theme = ThemeManager.currentTheme()
        
        settings.style.selectedBarBackgroundColor = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
        settings.style.selectedBarHeight = 3
        buttonBarView.backgroundColor = theme.primaryColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemBackgroundColor = theme.primaryColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.white.withAlphaComponent(0.6)
            newCell?.label.textColor = .white
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let line = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LineChartVC")
        let radar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RadarChartVC")
        let bar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarChartVC")
        return [line, radar, bar]
    }
}

extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}
