//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import Lottie
import Material
import SwiftyJSON
import GoogleMobileAds
import MaterialComponents
import CustomIOSAlertView
import DGElasticPullToRefresh

var subjects = [Subject]()
var attendances = [Attendance]()
var studentInfo = StudentInformation(json: "{}")

var disabled = false
// Don't need to localize these
// cuz the server shall always return a title & message when disabled
// these are JUST IN CASE
var disabled_title = "Access is denied"
var disabled_message = "PowerSchool 目前被学校禁用，请联系学校以获得更多信息。"

class MainTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var bannerView: GADBannerView!
    var loadingView: DGElasticPullToRefreshLoadingViewCircle!
    var GPADialog = GPADialogUtil()
    var birthdayDialogAlert: CustomIOSAlertView!
    
    let kRowsCount = 30
    let kOpenCellHeight: CGFloat = 315
    let kCloseCellHeight: CGFloat = 125
    var cellHeights: [CGFloat] = []
    var storedOffsets = [Int: CGFloat]()
    let kSectionHeaderHeight: CGFloat = 16
    
    var theme = ThemeManager.currentTheme()
    
    var needShowDonate = false
    var needDisplayILD = false
    var ILDInfo: ILDNotification!
    
    override func viewWillAppear(_ animated: Bool) {
        
        theme = ThemeManager.currentTheme()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let gpaItem = UIBarButtonItem(image: UIImage(named: "ic_grade_white")?.withRenderingMode(.alwaysOriginal),
                                      style: .plain, target: self, action: #selector(gpaOnClick))
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal),
                                       style: .plain, target: self, action: #selector(menuOnClick))
        
        self.navigationItem.rightBarButtonItems = [gpaItem]
        self.navigationItem.leftBarButtonItems = [menuItem]
        if (Utils.isBirthDay()) { showBirthdayButton() }
        
        self.navigationController?.navigationBar.barTintColor = theme.primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.navigationDrawerController?.isLeftViewEnabled = true
        
        self.title = "dashboard".localize
        self.tableView.layoutIfNeeded()
        fetchLocalILD()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTheme),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView),
                                               name:NSNotification.Name(rawValue: "updateLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView),
                                               name:NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    override func viewDidLoad() {
        
        theme = ThemeManager.currentTheme()
        super.viewDidLoad()
        
        initBannerView()
        initUI()
        initValue()
        
        if ON_SHORTCUT != .none {
            handleShortcutAction()
        }
        
        // send device token for notification
        let token = userDefaults.string(forKey: TOKEN_KEY_NAME)
        if token != nil && token != "" { Utils.sendNotificationRegistry(token: token!) }
    }
    
    deinit {
        if tableView != nil {
            tableView.dg_removePullToRefresh()
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateShowInactive"), object: nil)
    }
    
    @objc func updateTheme() {
        
        theme = ThemeManager.currentTheme()
        initTableView()
        tableView.reloadData()
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    func initValue() {
        
        let input = Utils.readDataArrayList()
        if input != nil {
            (_, attendances, subjects, disabled, disabled_title, disabled_message, _) = input!
        }
        if self.navigationController?.view.tag == 1 {
            initDataJson()
        }
    }
    
    func initUI() {
        initTableView()
        fetchILD()
    }
    
    func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSize.init(size: CGSize.init(width: 320, height: 50), flags: 0))
        bannerView.frame = CGRect.init(x: (self.view.frame.size.width - 320) / 2,
                                       y: self.view.frame.size.height - 50, width: 320, height: 50)
        
        self.view.addSubview(bannerView)
        let horizontalConstraint = NSLayoutConstraint(item: bannerView, attribute: NSLayoutAttribute.centerX,
                                                      relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX,
                                                      multiplier: 1, constant: 0)
        self.view.addConstraints([horizontalConstraint])
        
        bannerView.adUnitID = ADMOB_APP_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func initTableView() {
//        Keep these for emergency [AUG 28 2018].
//        tableView.estimatedRowHeight = kCloseCellHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.backgroundColor = theme.windowBackgroundColor
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsetsMake(0, 0, bannerView.frame.height, 0)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionHeaderHeight = 300;
        tableView.layoutIfNeeded()
        initRefreshView()
    }
    
    func initRefreshView() {
        
        loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = Utils.getAccent()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in self?.initDataJson() },
                                                       loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(theme.primaryColor)
        tableView.dg_setPullToRefreshBackgroundColor(theme.windowBackgroundColor)
    }
    
    func handleShortcutAction() {
        switch ON_SHORTCUT {
        case .gpa:
            gpaOnClick()
            break
        case .chart:
            (navigationDrawerController?.leftViewController as! LeftViewController).presentFragment = 1
            (navigationDrawerController?.leftViewController as! LeftViewController).gotoFragment(section: 0, location: 1)
            break
        case .attendance:
            (navigationDrawerController?.leftViewController as! LeftViewController).presentFragment = 2
            (navigationDrawerController?.leftViewController as! LeftViewController).gotoFragment(section: 0, location: 2)
            break
        case .none:
            return
        }
        ON_SHORTCUT = .none
    }
    
    @objc func fabOnClick(sender: UIButton) {
        performSegue(withIdentifier: "gotoDetail", sender: sender)
    }
    
    @objc func menuOnClick() {
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }
    
    @objc func gpaOnClick() {
        
        self.GPADialog = GPADialogUtil(view: UIApplication.shared.delegate?.window??.rootViewController?.view ?? self.view,
                                       subjectsForGPA: subjects,
                                       GPAOfficial: studentInfo.GPA ?? Double.nan)
        if subjects.count == 0 {
            self.GPADialog.GPANotAvailable()
        } else {
            print("efihfish")
            self.GPADialog.show()
        }
    }
    
    func showBirthdayButton() {
        
        let birthdayButton = MDCFloatingButton(shape: .mini)
        let animationView = LOTAnimationView(name: "cheer")
        animationView.loopAnimation = true
        animationView.frame = CGRect(x: 6, y: 5, width: 28, height: 28)
        animationView.isUserInteractionEnabled = false
        birthdayButton.setBackgroundColor(.clear)
        birthdayButton.setShadowColor(.clear, for: .normal)
        birthdayButton.addSubview(animationView)
        birthdayButton.addTarget(self, action: #selector(birthdayOnClick), for: .touchUpInside)
        let birthdayItem = UIBarButtonItem(customView: birthdayButton)
        (birthdayItem.customView?.subviews[(birthdayItem.customView?.subviews.count)! - 1] as! LOTAnimationView).play()
        self.navigationItem.rightBarButtonItems?.append(birthdayItem)
    }
    
    @objc func birthdayOnClick() {
        
        let standerdWidth = self.view.frame.width * 0.8
        birthdayDialogAlert = CustomIOSAlertView(parentView: UIApplication.shared.delegate?.window??.rootViewController?.view ?? self.view)
        let birthdayDialog = BirthdayDialog.instanceFromNib(width: standerdWidth)
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: birthdayDialog.bounds.size.height))
        (birthdayDialog.viewWithTag(5) as! MDCFlatButton).addTarget(self, action: #selector(dismissBirthday), for: .touchUpInside)
        birthdayDialog.center = subview.center
        subview.addSubview(birthdayDialog)
        birthdayDialogAlert?.containerView = subview
        birthdayDialogAlert?.closeOnTouchUpOutside = true
        birthdayDialogAlert?.buttonTitles = nil
        birthdayDialogAlert?.show()
    }
    
    @objc func dismissBirthday() {
        if birthdayDialogAlert != nil {
            birthdayDialogAlert.close()
        }
    }
}

//MARK: Data Json
extension MainTableViewController {
    
    func fetchLocalILD() {
        let data = userDefaults.string(forKey: LOCAL_ILD_KEY_NAME) ?? ""
        var showed = false
        if data.contains("{") {
            showed = self.showILD(data: ILDNotification(json: JSON(parseJSON: data)))
        }
        if !showed {
            showDonateIfNeeded()
        }
    }
    
    func fetchILD() {
        Utils.sendGet(
            url: ILD_URL,
            params: "") { (value) in
            let response = value
            if response.contains("{") {
                self.needShowDonate = false
                self.userDefaults.set(response, forKey: LOCAL_ILD_KEY_NAME)
            }
            self.fetchLocalILD()
        }
    }
    
    func initDataJson() {
        
        var oldSubjects = [Subject]()
        var oldAttendances = [Attendance]()
        let username = userDefaults.string(forKey: USERNAME_KEY_NAME)
        let password = userDefaults.string(forKey: PASSWORD_KEY_NAME)
        oldSubjects += subjects
        oldAttendances += attendances
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        Utils.sendPost(
            url: GET_DATA_URL,
            params: "username=\(username!)" +
                "&password=\(password!)" +
                "&version=\(version)" +
                "&os=ios" +
        "&action=manual_get_data") { (value) in
            
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
                self.logOut()
                
            } else if response.contains("{") {
                
                let extraInfo: Utils.ExtraInfo
                
                Utils.saveStringToFile(filename: JSON_FILE_NAME, data: response)
                (studentInfo, attendances, subjects, disabled, disabled_title, disabled_message, extraInfo) = Utils.parseJsonResult(jsonStr: response)
                
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
                
                Utils.saveHistoryGrade(data: subjects)
                self.userDefaults.set(studentInfo.dob, forKey: STUDENT_DOB_KEY_NAME)
                self.userDefaults.set(extraInfo.avatar, forKey: USER_AVATAR_KEY_NAME)
                
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
                                
                                var oldPercent = 0
                                var newPercent = 0
                                let oldPercentStr = Utils.getLatestItemGrade(grades: oldSubjects[i].grades).percentage
                                let newPercentStr = Utils.getLatestItemGrade(grades: subjects[i].grades).percentage
                                if oldPercentStr != "--" { oldPercent = Int.init(oldPercentStr)! }
                                if newPercentStr != "--" { newPercent = Int.init(newPercentStr)! }
                                
                                if oldPercent != newPercent {
                                    item.margin = newPercent - oldPercent
                                }
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
    
    func logOut() {
        
        userDefaults.set(false, forKey: LOGGED_IN_KEY_NAME)
        Utils.saveHistoryGrade(data: nil)
        Utils.saveStringToFile(filename: JSON_FILE_NAME, data: "")
        startLoginController()
    }
    
    func startLoginController() {
        
        UIApplication.shared.delegate?.window??.rootViewController!
            .present(UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "login"),
                     animated: true, completion: updateRootViewController)
    }
    
    func updateRootViewController() {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let loginController = story.instantiateViewController(withIdentifier: "login")
        UIApplication.shared.delegate?.window??.rootViewController = loginController
    }
    
    func showSnackbar(msg: String) {
        
        let message = MDCSnackbarMessage()
        message.text = msg
        message.duration = 2    // 2s
        MDCSnackbarManager.show(message)
    }
    
    func needToShowDonate() -> Bool {
        // Show donate every 30 days
        if isDonated() || isEarlyDonators() {
            return false
        } else {
            return getLastDonateShowedDate().timeIntervalSinceNow * -1 / 60.0 / 60.0 / 24.0 >= 30.0
        }
//                return getLastDonateShowedDate().timeIntervalSinceNow * -1 >= 10.0
//                        return true
    }
    
    func isEarlyDonators() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let start120 = formatter.date(from: "2018/07/01")!
        let end120 = formatter.date(from: "2018/08/28")!
        return getLastDonateShowedDate().isBetweeen(date: start120, andDate: end120)
    }
    
    func isDonated() -> Bool {
        return userDefaults.bool(forKey: DONATED_KEY_NAME)
    }
    
    func getLastDonateShowedDate() -> Date {
        let df = DateFormatter()
        let dateStr = userDefaults.string(forKey: LAST_TIME_DONATION_SHOWED_KEY_NAME) ?? ""
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if dateStr != "" { return df.date(from: dateStr)! }
        else { return Date(timeIntervalSince1970: 0) }
    }
    
    func setLastDonateShowedDate(date: Date) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        userDefaults.set(df.string(from: date), forKey: LAST_TIME_DONATION_SHOWED_KEY_NAME)
    }
    
    @objc func gotoDonation() {
        userDefaults.set(true, forKey: IM_COMING_FOR_DONATION_KEY_NAME)
        (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Support Us"), animated: true)
        setLastDonateShowedDate(date: Date.init())
        needShowDonate = false
        dismissAllILD()
    }
    
    @objc func gotoPromotion() {
        (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Support Us"), animated: true)
        setLastDonateShowedDate(date: Date.init())
        needShowDonate = false
        dismissAllILD()
    }
    
    @objc func dismissDonation() {
        setLastDonateShowedDate(date: Date.init())
        needShowDonate = false
        dismissAllILD()
    }
    
    @objc func dismissAllILD() {
        
        if needDisplayILD && ILDInfo != nil {
            if ILDInfo.onlyOnce {
                var displayedILDs = userDefaults.stringArray(forKey: DISPLAYED_ILD_KEY_NAME) ?? [String]()
                displayedILDs.append(ILDInfo.uuid)
                userDefaults.set(displayedILDs, forKey: DISPLAYED_ILD_KEY_NAME)
            }
        }
        
        needDisplayILD = false
        ILDInfo = nil
        DispatchQueue.main.async {
            self.tableView.sectionHeaderHeight = self.kSectionHeaderHeight
            self.tableView.reloadSections([0], with: .top)
        }
    }
    
    private func showDonateIfNeeded() {
        if (self.needToShowDonate()) {
            self.needShowDonate = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func showILD(data: ILDNotification) -> Bool {
        
        let displayedILDs = userDefaults.stringArray(forKey: DISPLAYED_ILD_KEY_NAME) ?? [String]()
        if !displayedILDs.contains(data.uuid) {
            if data.show {
                needDisplayILD = true
                ILDInfo = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return true
            }
        }
        return false
    }
}

//MARK: Table View
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if Utils.getFilteredSubjects(subjects: subjects).count == 0 {
            // If there's no cource, always show NothingView
            tableView.backgroundView = NothingView.instanceFromNib(width: tableView.width, height: tableView.height, image: ThemeManager.currentTheme().noGradeImage, text: "nothing_here".localize)
            tableView.backgroundView?.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        } else {
            tableView.backgroundView = nil
            
            if needDisplayILD {
                
                var lang = 0
                switch DGLocalization.sharedInstance.getCurrentLanguage().languageCode {
                case "en": lang = 0
                case "zh-Hans": lang = 1
                case "zh-Hant": lang = 2
                default: lang = 0
                }
                
                tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
                let view = InListDialog.instanceFromNib(
                    imageURL: URL(string: ILDInfo.headerImageURL)!,
                    title: ILDInfo.titles[lang],
                    message: ILDInfo.messages[lang],
                    primaryText: ILDInfo.primaryTexts[lang],
                    secondaryText: ILDInfo.secondaryTexts[lang],
                    dismissText: ILDInfo.dismissTexts[lang]
                )
                
                (view.viewWithTag(4) as! MDCFlatButton).addTarget(self, action: #selector(dismissAllILD), for: .touchUpInside)
                (view.viewWithTag(5) as! MDCFlatButton).gone(yes: ILDInfo.hideSecondary)
                (view.viewWithTag(6) as! MDCFlatButton).gone(yes: ILDInfo.hideDismiss)
                
                return view
                
            } else if needShowDonate {
                
                // Show donation dialog as header
                tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
                let donation = ILDNotification(json: JSON())
                donation.show = true
                let view = InListDialog.instanceFromNib(
                    imageURL: Bundle.main.url(forResource: "illu_donation", withExtension: "svg")!,
                    title: "donation_title".localize,
                    message: "donation_message".localize,
                    primaryText: "donation_ok".localize,
                    secondaryText: "donation_promote".localize,
                    dismissText: "donation_cancel".localize)
                (view.viewWithTag(4) as! MDCFlatButton).addTarget(self, action: #selector(gotoDonation), for: .touchUpInside)
                (view.viewWithTag(5) as! MDCFlatButton).addTarget(self, action: #selector(gotoPromotion), for: .touchUpInside)
                (view.viewWithTag(6) as! MDCFlatButton).addTarget(self, action: #selector(dismissDonation), for: .touchUpInside)
                
                return view
                
            } else {
                tableView.sectionHeaderHeight = kSectionHeaderHeight
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.getFilteredSubjects(subjects: subjects).count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as DashboardCell = cell else {
            return
        }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        cell.selectedBackgroundView = nil
        cell.backgroundColor = .clear
        cell.number = indexPath.row
        cell.infoItem = Utils.getFilteredSubjects(subjects: subjects)[indexPath.row]
        cell.backViewColor = theme.cardBackgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath?) {
        
        if (indexPath == nil) { return  }
        guard let tableViewCell = cell as? DashboardCell else { return }
        storedOffsets[indexPath!.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        let button = FABButton(image: UIImage(named: "ic_keyboard_arrow_right_white_36pt"), tintColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Utils.getAccent()
        button.shadowOffset = CGSize.init(width: 0, height: 2.5)
        button.shadowRadius = 2
        button.shadowOpacity = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(MainTableViewController.fabOnClick), for: .touchUpInside)
        cell.containerView.addSubview(button)
        
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell.containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -17.5)
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell.containerView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -63)
        
        cell.containerView.addConstraints([heightConstraint, widthConstraint, verticalConstraint, horizontalConstraint])
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cell.unfold(true, animated: true, completion: nil)
            cellHeights[indexPath.row] = kOpenCellHeight
            duration = 0.5
        } else {
            cell.unfold(false, animated: true, completion: nil)
            cellHeights[indexPath.row] = kCloseCellHeight
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var bannerFrame = self.bannerView.frame
        bannerFrame.origin.y = self.view.frame.size.height - 50 + self.tableView.contentOffset.y
        self.bannerView.frame = bannerFrame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetail" {
            (segue.destination as? CourseDetailTableViewController)?.infoItem = Utils.getFilteredSubjects(subjects: subjects)[(sender as! UIButton).tag]
            (segue.destination as? CourseDetailTableViewController)?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

//MARK: Collection View
extension MainTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Utils.getFilteredSubjects(subjects: subjects)[collectionView.tag].grades.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "PeriodGradeListItem", bundle: nil), forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 75.0, height: 96.0)
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        collectionCell.layer.cornerRadius = 7.0
        collectionCell.layer.masksToBounds = true
        collectionCell.layer.shouldRasterize = true
        collectionCell.layer.rasterizationScale = UIScreen.main.scale
        collectionCell.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        collectionCell.layer.shadowRadius = 1
        collectionCell.layer.shadowOpacity = 0.2
        
        let grades = Utils.getFilteredSubjects(subjects: subjects)[collectionView.tag].grades
        let termName = Array(grades.keys)[indexPath.row]
        let grade = grades[termName]!
        (collectionCell.viewWithTag(1) as! UILabel).textColor = theme.primaryTextColor
        (collectionCell.viewWithTag(1) as! UILabel).text = termName
        (collectionCell.viewWithTag(2) as! UILabel).text = grade.letter
        (collectionCell.viewWithTag(3) as! UILabel).text = grade.percentage
        collectionCell.viewWithTag(4)?.backgroundColor = theme.windowBackgroundColor
        
        collectionCell.backgroundColor = Utils.getColorByGrade(item: grade)
        
        return collectionCell
    }
    
    //MARK: TERM ONCLICK, SHOW TERM DIALOG
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let grades = Utils.getFilteredSubjects(subjects: subjects)[collectionView.tag].grades
        let termName = Array(grades.keys)[indexPath.row]
        let grade = grades[termName]!
        let standerdWidth = self.view.frame.width * 0.8
        let alert = CustomIOSAlertView(parentView: UIApplication.shared.delegate?.window??.rootViewController?.view ?? self.view)
        let termDialog = TermDialog.instanceFromNib(
            width: standerdWidth,
            name: termName,
            subject: Utils.getFilteredSubjects(subjects: subjects)[collectionView.tag].title,
            grade: grade)
        
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: termDialog.bounds.size.height))
        termDialog.center = subview.center
        subview.addSubview(termDialog)
        alert?.containerView = subview
        alert?.closeOnTouchUpOutside = true
        alert?.buttonTitles = nil
        alert?.show()
    }
}

extension UIView {
    
    func gone(yes: Bool) {
        if yes {
            for constraint in self.constraints {
                constraint.constant = 0
            }
            self.isHidden = true
            self.layoutIfNeeded()
        }
    }
}

extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}
