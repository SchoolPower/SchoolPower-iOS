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
import GoogleMobileAds
import MaterialComponents
import DGElasticPullToRefresh

class AttendanceTableViewController: UITableViewController {
    
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
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
        tableView.contentInset = UIEdgeInsetsMake(0, 0, bannerView.frame.height, 0)
    }
    
    func initRefreshView() {
        
        loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
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
        let horizontalConstraint = NSLayoutConstraint(item: bannerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([horizontalConstraint])
        
        /* TEST ID */
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = "ca-app-pub-9841217337381410/7561186325"
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
            
            if response.contains("Something went wrong! Invalid Username or password") {
                
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
                    self.showDisabledDialog(title: disabled_title, message: disabled_message)
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
            tableView.backgroundView = NothingView.instanceFromNib(width: tableView.width, height: tableView.height, image: ThemeManager.currentTheme().perfectAttendanceImage, text: "perfect_attendance".localize)
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
