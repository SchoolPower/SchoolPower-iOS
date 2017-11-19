//
//  Copyright 2017 SchoolPower Studio

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
import FoldingCell
import GoogleMobileAds
import MaterialComponents
import CustomIOSAlertView
import DGElasticPullToRefresh

var subjects = [Subject]()
var filteredSubjects = [Subject]()
var attendances = [Attendance]()

class MainTableViewController: UITableViewController {

    var bannerView: GADBannerView!
    var loadingView: DGElasticPullToRefreshLoadingViewCircle!

    let kRowsCount = 30
    let kOpenCellHeight: CGFloat = 315
    let kCloseCellHeight: CGFloat = 125
    var cellHeights: [CGFloat] = []
    var storedOffsets = [Int: CGFloat]()

    let userDefaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        let gpaItem = UIBarButtonItem(image: UIImage(named: "ic_grade_white")?.withRenderingMode(.alwaysOriginal),
                style: .plain, target: self, action: #selector(gpaOnClick))
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal),
                style: .plain, target: self, action: #selector(menuOnClick))
        self.navigationItem.rightBarButtonItems = [gpaItem]
        navigationItem.leftBarButtonItems = [menuItem]

        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        self.title = "dashboard".localize
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFilteredSubjects),
                name:NSNotification.Name(rawValue: "updateFilteredSubjects"), object: nil)

        tableView.reloadData()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        initValue()
        
        // send device token for notification
        let token = self.userDefaults.string(forKey: TOKEN_KEY_NAME)
        if token != nil && token != "" { Utils.sendNotificationRegistry(token: token!) }
    }

    deinit {
        if tableView != nil {
            tableView.dg_removePullToRefresh()
        }
    }
    
    func updateFilteredSubjects(){
        
        if (!userDefaults.bool(forKey: SHOW_INACTIVE_KEY_NAME)) {
            filteredSubjects = [Subject]()
            for subject in subjects{
                if subject.getLatestItemGrade().letter != "--" || !subject.assignments.isEmpty {
                    filteredSubjects.append(subject)
                }
            }
        }else{
            filteredSubjects = subjects
        }
    }
    
    func initValue() {

        initUI()
        let input = Utils.readDataArrayList()
        if input != nil {
            (_,attendances,subjects) = input!
            updateFilteredSubjects()
        }
        if self.navigationController?.view.tag == 1 {
            initDataJson()
        }
    }

    func initUI() {

        initBannerView()
        initTableView()
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

        /* TEST ID */
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = "ca-app-pub-9841217337381410/3714312680"
        bannerView.rootViewController = self

        bannerView.load(GADRequest())
    }

    func initTableView() {

        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(rgb: Colors.foreground_material_dark)
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsetsMake(0, 0, bannerView.frame.height, 0)
        initRefreshView()
    }

    func initRefreshView() {

        loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(rgb: Colors.accent)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in self?.initDataJson() },
                loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(rgb: Colors.primary))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    func fabOnClick(sender: UIButton) {
        performSegue(withIdentifier: "gotoDetail", sender: sender)
    }

    func menuOnClick(sender: UINavigationItem) {

        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }

    func gpaOnClick(sender: UINavigationItem) {

        if subjects.count == 0 {

            UIAlertView(title: "gpa_not_available".localize, message: "gpa_not_available_because".localize,
                    delegate: nil, cancelButtonTitle: "alright".localize)
                    .show()

        } else {

            var sum = 0.0
            var exhr = 0.0
            var exhrme = 0.0
            var contain_hr = false
            var contain_me = false
            var num = 0
            var periodApplied = ""
            for subject in subjects {
                let periodName = subject.getLatestItem()
                if periodName != "--" {
                    if periodApplied=="" { periodApplied = periodName }
                    let period = subject.grades[periodName]
                    if period == nil || period!.letter == "--" { continue }
                    let grade = Double(period!.percentage)!
                    sum += grade
                    num += 1
                    if subject.title.contains("Homeroom") {
                        contain_hr = true
                        continue
                    }
                    exhr += grade
                    if subject.title.contains("Moral Education") {
                        contain_me = true
                        continue
                    }
                    exhrme += grade
                }
            }
            if num == 0 {
                UIAlertView(title: "gpa_not_available".localize, message: "gpa_not_available_because".localize,
                        delegate: nil, cancelButtonTitle: "alright".localize)
                        .show()
                return
            }
            let doubleNum = Double(num)
            let standerdWidth = self.view.frame.width * 0.8
            let alert = CustomIOSAlertView.init()
            let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: standerdWidth * 1.5))
            let gpaDialog = GPADialog.instanceFromNib(width: standerdWidth)
            let gpaSegments = gpaDialog.viewWithTag(2) as? GPASegmentedControl

            percentageLabel?.format = "%.3f%%"
            descriptionLabel?.text = String(format: "gpamessage".localize, periodApplied)
            ring?.ring1.startColor = Utils.getColorByLetterGrade(
                    letterGrade: Utils.getLetterGradeByPercentageGrade(percentageGrade: sum / doubleNum))
            ring?.ring1.endColor = (ring?.ring1.startColor)!.lighter(by: 10)!

            gpaSegments?.sum = sum / doubleNum / 100
            var num_to_minus: Double = 0.0
            if (contain_hr) {
                num_to_minus += 1
            }
            gpaSegments?.exhr = exhr / (doubleNum - num_to_minus) / 100
            if (contain_me) {
                num_to_minus += 1
            }
            gpaSegments?.exhrme = exhrme / (doubleNum - num_to_minus) / 100

            gpaSegments?.setTitle("all".localize, forSegmentAt: 0)
            gpaSegments?.apportionsSegmentWidthsByContent = true
            gpaSegments?.addTarget(self, action: #selector(animateProgressView), for: .valueChanged)
            gpaDialog.center = subview.center
            subview.addSubview(gpaDialog)

            alert?.containerView = subview
            alert?.closeOnTouchUpOutside = true
            alert?.buttonTitles = nil
            alert?.show()

            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.animateProgressView(sender: gpaSegments!)
            }
        }
    }

    func animateProgressView(sender: GPASegmentedControl) {

        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)

        var value: Double = 0
        let formerStr = percentageLabel?.text ?? ""
        var strPos: Float = 0
        if formerStr != "" {
            strPos = Float((formerStr.substring(to: formerStr.index(formerStr.endIndex, offsetBy: -1))))!
        }

        switch sender.selectedSegmentIndex {
        case 0: value = sender.sum!
        case 1: value = sender.exhr!
        case 2: value = sender.exhrme!
        default: value = sender.sum ?? 0
        }

        ring?.ring1.progress = value
        ring?.ring1.startColor = Utils.getColorByLetterGrade(
                letterGrade: Utils.getLetterGradeByPercentageGrade(percentageGrade: value * 100))
        ring?.ring1.endColor = (ring?.ring1.startColor)!.lighter(by: 10)!
        percentageLabel?.countFrom(fromValue: strPos, to: Float(value * 100), withDuration: 1.0,
                andAnimationType: .EaseOut, andCountingType: .Custom)

        CATransaction.commit()
    }
}

//MARK: Data Json
extension MainTableViewController {

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

            if response.contains("Something went wrong! Invalid Username or password") {

                self.showSnackbar(msg: "invalidup".localize)
                self.logOut()
                
            } else if response.contains("{") {

                Utils.saveStringToFile(filename: JSON_FILE_NAME, data: response)
                (_, attendances, subjects) = Utils.parseJsonResult(jsonStr: response)
                
                self.updateFilteredSubjects()
                Utils.saveHistoryGrade(data: subjects)

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
        message.duration = 2
        MDCSnackbarManager.show(message)
    }
}

//MARK: Table View
extension MainTableViewController {

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: "MainHeaderCell")
        return headerCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if filteredSubjects.count == 0 {
            tableView.backgroundView = NothingView.instanceFromNib(width: tableView.width, height: tableView.height, image: #imageLiteral(resourceName: "no_grades"), text: "nothing_here".localize)
            tableView.dg_setPullToRefreshBackgroundColor(UIColor(rgb: Colors.nothing_light))
            return 0

        } else {
            tableView.backgroundView = nil
            tableView.dg_setPullToRefreshBackgroundColor(UIColor(rgb: Colors.foreground_material_dark))
            return 20
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSubjects.count
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
        cell.backgroundColor = .clear
        cell.number = indexPath.row
        cell.infoItem = filteredSubjects[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath?) {
        if (indexPath == nil) {
            return
        }
        guard let tableViewCell = cell as? DashboardCell else {
            return
        }
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
        button.backgroundColor = UIColor(rgb: Colors.accent)
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
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
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
            (segue.destination as? CourseDetailTableViewController)?.infoItem = filteredSubjects[(sender as! UIButton).tag]
            (segue.destination as? CourseDetailTableViewController)?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

//MARK: Collection View
extension MainTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSubjects[collectionView.tag].grades.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        collectionView.register(UINib(nibName: "PeriodGradeListItem", bundle: nil), forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 75.0, height: 96.0)

        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        collectionCell.layer.cornerRadius = 7.0
        collectionCell.layer.masksToBounds = true

        let grades = filteredSubjects[collectionView.tag].grades
        let termName = Array(grades.keys)[indexPath.row]
        let grade = grades[termName]!
        (collectionCell.viewWithTag(1) as! UILabel).text = termName
        (collectionCell.viewWithTag(2) as! UILabel).text = grade.letter
        (collectionCell.viewWithTag(3) as! UILabel).text = grade.percentage
        collectionCell.backgroundColor = Utils.getColorByGrade(item: grade)

        return collectionCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}

class GPASegmentedControl: UISegmentedControl {

    var sum: Double?
    var exhr: Double?
    var exhrme: Double?
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {

        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue - percentage / 100,
                    saturation: saturation + percentage / 100,
                    brightness: brightness + percentage / 100,
                    alpha: alpha)
        } else {
            return nil
        }
    }
}

