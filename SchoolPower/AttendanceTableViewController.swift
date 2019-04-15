//
//  Copyright 2019 SchoolPower Studio
//

import UIKit
import Material
import GoogleMobileAds
import MaterialComponents
import DGElasticPullToRefresh

class AttendanceTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var bannerView: GADBannerView!
    var attendanceList: [Attendance] = Array()
    var loadingView: DGElasticPullToRefreshLoadingViewCircle!
    var theme = ThemeManager.currentTheme()
    
    override func viewWillAppear(_ animated: Bool) {
        
        theme = ThemeManager.currentTheme()
        self.title = "attendance".localize
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) ,
                                       style: .plain ,target: self, action: #selector(menuOnClick))
        self.navigationItem.leftBarButtonItems = [menuItem]
        self.navigationController?.navigationBar.barTintColor = theme.primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.navigationDrawerController?.isLeftViewEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTheme),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initBannerView()
        setup()
    }
    
    @objc func updateTheme() {
        
        setup()
        tableView.reloadData()
    }
    
    private func setup() {
        
        initRefreshView()
        attendanceList = attendances
        theme = ThemeManager.currentTheme()
        tableView.backgroundColor = theme.windowBackgroundColor
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: bannerView.frame.height, right: 0)
    }
    
    func initRefreshView() {
        
        loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = Utils.getAccent()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in self?.initDataJson() },
                                                       loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(theme.primaryColor)
        tableView.dg_setPullToRefreshBackgroundColor(theme.windowBackgroundColor)
    }
    
    deinit {
        if tableView != nil {
            tableView.dg_removePullToRefresh()
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSize.init(size: CGSize.init(width: 320, height: 50), flags: 0))
        bannerView.frame = CGRect.init(x: (self.view.frame.size.width - 320) / 2,
                                       y: self.view.frame.size.height - 50, width: 320, height: 50)
        
        self.view.addSubview(bannerView)
        let horizontalConstraint = NSLayoutConstraint(item: bannerView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([horizontalConstraint])
        
        bannerView.adUnitID = ADMOB_APP_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func initDataJson() {
        
        var oldSubjects = [Subject]()
        var oldAttendances = [Attendance]()
        let username = userDefaults.string(forKey: USERNAME_KEY_NAME)
        let password = userDefaults.string(forKey: PASSWORD_KEY_NAME)
        oldSubjects += subjects
        oldAttendances += attendances
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        Utils.sendPost(url: GET_DATA_URL,
                       params: "username=\(username!)" +
                        "&password=\(password!)" +
                        "&version=\(version)" +
                        "&os=ios&action=manual_get_data") { (value) in
            
            let response = value
            if response.contains("NETWORK_ERROR") {
                
                DispatchQueue.main.async {
                    self.tableView.dg_stopLoading()
                    self.showSnackbar(msg: "cannot_connect".localize)
                }
                return
            }
            
            if response.contains("Something went wrong!") {
                
                self.showSnackbar(msg: "invalidup".localize)
                //self.logOut()
                
            } else if response.contains("{") {
                
                var disabled = false
                // Don't need to localize these
                // cuz the server shall always return a title & message when disabled
                // these are JUST IN CASE
                var disabled_title = "Access is denied"
                var disabled_message = "PowerSchool 目前被学校禁用，请联系学校以获得更多信息。"

                Utils.saveStringToFile(filename: JSON_FILE_NAME, data: response)
                (_, attendances, subjects, disabled, disabled_title, disabled_message, _) = Utils.parseJsonResult(jsonStr: response)
                
                Utils.saveHistoryGrade(data: subjects)
                
                if disabled {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.tableView.dg_stopLoading()
                            self.tableView.reloadData()
                            self.showDisabledDialog(title: disabled_title, message: disabled_message)
                        }
                    }
                    return
                }
                
                // Diff
                if subjects.count == oldSubjects.count && !subjects.isEmpty {
                    for i in 0...subjects.count - 1 {
                        
                        let newAssignmentListCollection = subjects[i].assignments
                        let oldAssignmentListCollection = oldSubjects[i].assignments
                        for item in newAssignmentListCollection {
                            
                            var found = false
                            for it in oldAssignmentListCollection {
                                
                                if (it.title == item.title && it.score == item.score
                                    && it.date == item.date && !it.isNew) {
                                    found = true
                                }
                            }
                            if !found {
                                item.isNew = true
                            }
                        }
                        
                    }
                }
                for item in attendances {
                    
                    var found = false
                    for it in oldAttendances {
                        
                        if (it.subject == item.subject && it.period == item.period
                            && it.date == item.date && !it.isNew) {
                            found = true
                        }
                    }
                    if !found {
                        item.isNew = true
                    }
                }
                self.attendanceList = attendances
                DispatchQueue.main.async {
                    
                    self.tableView.dg_stopLoading()
                    self.tableView.reloadData()
                }
                self.showSnackbar(msg: "data_updated".localize)
                
                
            } else {
                
                DispatchQueue.main.async {
                    self.tableView.dg_stopLoading()
                }
                self.showSnackbar(msg: "cannot_connect".localize)
            }
        }
    }
    
    func showDisabledDialog(title: String, message: String) {
        UIAlertView(title: title,
                    message: message,
                    delegate: nil,
                    cancelButtonTitle: "alright".localize)
            .show()
    }
    
    @objc func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }
    
    func showSnackbar(msg: String) {
        
        let message = MDCSnackbarMessage()
        message.text = msg
        message.duration = 2
        MDCSnackbarManager.show(message)
    }
}

//MARK: Table View
extension AttendanceTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if attendanceList.count == 0 {
            tableView.backgroundView = NothingView.instanceFromNib(width: tableView.bounds.size.width, height: tableView.bounds.size.height, image: ThemeManager.currentTheme().perfectAttendanceImage, text: "perfect_attendance".localize)
            tableView.backgroundView?.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
            return UIView()
            
        } else {
            tableView.backgroundView = nil
            
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailFooterCell")
            footerCell?.backgroundColor = .clear
            return footerCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var bannerFrame = self.bannerView.frame
        bannerFrame.origin.y = self.view.frame.size.height - 50 + self.tableView.contentOffset.y
        self.bannerView.frame = bannerFrame
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as AttendanceCell = cell else { return }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.location = indexPath.row
        cell.attendance = attendanceList
    }
    
}
