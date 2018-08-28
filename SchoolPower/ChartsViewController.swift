//
//  Copyright 2018 SchoolPower Studio
//

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
        
        self.navigationDrawerController?.isLeftViewEnabled = true
        self.view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        
        do { try updateTheme() }
        catch { print("ChartsVC: Update theme failed!") }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    override func viewDidLoad() {
        
        initTabBar()
        super.viewDidLoad()
        self.reloadPagerTabStripView()
    }
    
    @objc func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }
    
    func updateTheme() throws -> Void {
        
        reloadViewFromNib()
        view.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        self.reloadPagerTabStripView()
    }
    
    @objc func loadTheView() {
        self.reloadPagerTabStripView()
    }
    
    func initTabBar() {

        let theme = ThemeManager.currentTheme()
        
        settings.style.selectedBarBackgroundColor = Utils.getAccent()
        settings.style.selectedBarHeight = 3
        buttonBarView.backgroundColor = theme.primaryColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemBackgroundColor = theme.primaryColor
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.imageView.contentMode = .center
            newCell?.imageView.contentMode = .center
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
