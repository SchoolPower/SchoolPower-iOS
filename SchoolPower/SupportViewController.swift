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

class SupportViewController: ButtonBarPagerTabStripViewController {
    
    let userDefaults = UserDefaults.standard
    fileprivate var firstLoaded = false
    
    let promotion = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PromotionVC")
    let donation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DonationVC")
    
    override func viewDidLoad() {
        
        initTabBar()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "support_us".localize
        self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationDrawerController?.isLeftViewEnabled = false
        self.view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: IM_COMING_FOR_DONATION_KEY_NAME) {
            self.moveTo(viewController: donation, animated: true)
            userDefaults.set(false, forKey: IM_COMING_FOR_DONATION_KEY_NAME)
        }
    }
    
    func initTabBar() {
        
        let theme = ThemeManager.currentTheme()
        
        settings.style.selectedBarBackgroundColor = Utils.getAccent()
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
        return [promotion, donation]
    }
}
