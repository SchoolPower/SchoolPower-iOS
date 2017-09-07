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
import MaterialComponents
import Material
import FoldingCell
import GoogleMobileAds
import CustomIOSAlertView
import DGElasticPullToRefresh

var dataList = [MainListItem]()

class MainTableViewController: UITableViewController {
    
    var bannerView: GADBannerView!
    var loadingView: DGElasticPullToRefreshLoadingViewCircle!
    
    let kRowsCount = 10
    let kOpenCellHeight: CGFloat = 315
    let kCloseCellHeight: CGFloat = 125
    var cellHeights: [CGFloat] = []
    var storedOffsets = [Int: CGFloat]()
    
    let userDefaults = UserDefaults.standard
    let JSON_FILE_NAME = "dataMap.json"
    let KEY_NAME = "loggedin"
    
    override func viewWillAppear(_ animated: Bool) {
        
        let gpaItem = UIBarButtonItem(image: UIImage(named: "ic_grade_white")?.withRenderingMode(.alwaysOriginal) , style: .plain ,target: self, action: #selector(gpaOnClick))
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) , style: .plain ,target: self, action: #selector(menuOnClick))
        self.navigationItem.rightBarButtonItems = [gpaItem]
        navigationItem.leftBarButtonItems = [menuItem]
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.title = "dashboard".localize
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initValue()
    }
    
    deinit {
        if tableView != nil { tableView.dg_removePullToRefresh() }
    }
    
    func initValue() {
        
        initUI()
        let input = Utils.readDataArrayList()
        if input != nil { dataList = input! }
        if self.navigationController?.view.tag == 1 { initDataJson() }
    }
    
    func initUI() {
        
        initBannerView()
        initTableView()
    }
    
    func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSize.init(size: CGSize.init(width: 320, height: 50), flags: 0))
        bannerView.frame = CGRect.init(x: (self.view.frame.size.width - 320) / 2, y: self.view.frame.size.height - 50, width: 320, height: 50)
        
        self.view.addSubview(bannerView)
        let horizontalConstraint = NSLayoutConstraint(item: bannerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
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
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in self?.initDataJson()}, loadingView: loadingView)
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
        
        if dataList.count == 0 {
            
            UIAlertView(title: "gpa_not_available".localize, message: "gpa_not_available_because".localize, delegate: nil, cancelButtonTitle: "alright".localize)
                .show()
            
        } else {
            
            var sum = 0.0
            var exhr = 0.0
            var exhrme = 0.0
            var contain_hr = false
            var contain_me = false
            var num = 0
            for subject in dataList {
                
                if let period = subject.getLatestItem() {
                    if period.termPercentageGrade=="--" { continue }
                    let grade = Double(period.termPercentageGrade)!
                    sum += grade
                    num += 1
                    if subject.subjectTitle.contains("Homeroom") {
                        contain_hr = true
                        continue
                    }
                    exhr += grade
                    if subject.subjectTitle.contains("Moral Education") {
                        contain_me = true
                        continue
                    }
                    exhrme += grade
                }
            }
            if num==0{
                UIAlertView(title: "gpa_not_available".localize, message: "gpa_not_available_because".localize, delegate: nil, cancelButtonTitle: "alright".localize)
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
            descriptionLabel?.text = String(format: "gpamessage".localize, dataList[0].getLatestItem()!.termIndicator)
            ring?.ring1.startColor = Utils.getColorByLetterGrade(letterGrade: Utils.getLetterGradeByPercentageGrade(percentageGrade: sum / doubleNum))
            ring?.ring1.endColor = (ring?.ring1.startColor)!.lighter(by: 10)!
            
            gpaSegments?.sum = sum / doubleNum / 100
            var num_to_minus: Double = 0.0
            if (contain_hr) { num_to_minus += 1 }
            gpaSegments?.exhr = exhr / (doubleNum - num_to_minus) / 100
            if (contain_me) { num_to_minus += 1 }
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
            DispatchQueue.main.asyncAfter(deadline: when){
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
        if formerStr != "" { strPos = Float((formerStr.substring(to: formerStr.index(formerStr.endIndex, offsetBy: -1))))! }
        
        switch sender.selectedSegmentIndex {
        case 0: value = sender.sum!
        case 1: value = sender.exhr!
        case 2: value = sender.exhrme!
        default: value = sender.sum ?? 0
        }
        
        ring?.ring1.progress = value
        ring?.ring1.startColor = Utils.getColorByLetterGrade(letterGrade: Utils.getLetterGradeByPercentageGrade(percentageGrade: value * 100))
        ring?.ring1.endColor = (ring?.ring1.startColor)!.lighter(by: 10)!
        percentageLabel?.countFrom(fromValue: strPos, to: Float(value * 100), withDuration: 1.0, andAnimationType: .EaseOut, andCountingType: .Custom)
        
        CATransaction.commit()
    }
}

//MARK: Data Json
extension MainTableViewController {
    
    func initDataJson() {
        
        var oldMainItemList = [MainListItem]()
        let username = userDefaults.string(forKey: "username")
        let password = userDefaults.string(forKey: "password")
        oldMainItemList += dataList
        Utils.sendPost(url: "https://api.schoolpower.studio:8443/api/ps.php", params: "username=" + username! + "&password=" + password!){ (value) in
            
            let response = value
            if response.contains("NETWORK_ERROR") {
                
                DispatchQueue.main.async {
                    self.tableView.dg_stopLoading()
                    self.showSnackbar(msg: "cannot_connect".localize)
                }
                return
            }
            
            let messages = response.components(separatedBy: "\n")
            if response.contains("error") {
                
                self.showSnackbar(msg: "invalidup".localize)
                self.logOut()
                
            } else if response.contains("[{\"") {
                
                if !response.contains("assignments") { return }
                if messages.count == 3 && !messages[1].isEmpty {
                    
                    let jsonStr = messages[1]
                    Utils.saveStringToFile(filename: self.JSON_FILE_NAME, data: jsonStr)
                    dataList = Utils.parseJsonResult(jsonStr: jsonStr)
                    Utils.saveHistoryGrade(data: dataList)
                    
                    // Diff
                    if dataList.count == oldMainItemList.count {
                        for i in 0...dataList.count-1 {
                            
                            let periods = dataList[i].periodGradeItemArray
                            let oldPeriods = oldMainItemList[i].periodGradeItemArray
                            if periods.count != oldPeriods.count { continue }
                            
                            for j in 0...periods.count-1 {
                                let newAssignmentListCollection = periods[j].assignmentItemArrayList
                                let oldAssignmentListCollection = oldPeriods[j].assignmentItemArrayList
                                for item in newAssignmentListCollection {
                                    
                                    var found = false
                                    for it in oldAssignmentListCollection {
                                        
                                        if(it.assignmentTitle == item.assignmentTitle && it.assignmentDividedScore == item.assignmentDividedScore && it.assignmentDate == item.assignmentDate && !it.isNew){
                                            found = true
                                        }
                                    }
                                    if !found { item.isNew = true }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        
                        self.tableView.dg_stopLoading()
                        self.tableView.reloadData()
                    }
                    self.showSnackbar(msg: "data_updated".localize)
                }
                
            } else if messages[1] == "[]"  {
                
                Utils.saveStringToFile(filename: self.JSON_FILE_NAME, data: messages[1])
                dataList = Utils.parseJsonResult(jsonStr: messages[1])
                DispatchQueue.main.async {
                    
                    self.tableView.dg_stopLoading()
                    self.tableView.reloadData()
                }
                self.showSnackbar(msg: "data_updated".localize)
                
            } else {
                
                DispatchQueue.main.async { self.tableView.dg_stopLoading() }
                self.showSnackbar(msg: "cannot_connect".localize)
            }
        }
    }
    
    func logOut() {
        
        userDefaults.set(false, forKey: KEY_NAME)
        Utils.saveHistoryGrade(data: nil)
        Utils.saveStringToFile(filename: self.JSON_FILE_NAME, data: "")
        startLoginController()
    }
    
    func startLoginController() {
        
        UIApplication.shared.delegate?.window??.rootViewController!.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login"), animated: true, completion: updateRootViewController)
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
        headerCell?.backgroundColor = .clear
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if dataList.count == 0 {
            
            tableView.backgroundView = NothingView.instanceFromNib(width: tableView.width, height: tableView.height)
            tableView.dg_setPullToRefreshBackgroundColor(UIColor(rgb: Colors.nothing_light))
            return 0
            
        } else {
            
            tableView.backgroundView = nil
            tableView.dg_setPullToRefreshBackgroundColor(UIColor(rgb: Colors.foreground_material_dark))
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as DashboardCell = cell else { return }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        if cellHeights[indexPath.row] == kCloseCellHeight { cell.unfold(false, animated: false, completion:nil) }
        else { cell.unfold(true, animated: false, completion: nil) }
        cell.backgroundColor = .clear
        cell.number = indexPath.row
        cell.infoItem = dataList[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath?) {
        if(indexPath==nil) { return }
        guard let tableViewCell = cell as? DashboardCell else { return }
        storedOffsets[indexPath!.row] = tableViewCell.collectionViewOffset
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.backViewColor = UIColor(rgb: Colors.cardview_dark_background)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        if cell.isAnimating() { return }
        
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
            (segue.destination as? CourseDetailTableViewController)?.infoItem = dataList[(sender as! UIButton).tag]
            (segue.destination as? CourseDetailTableViewController)?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        }
    }
}

//MARK: Collection View
extension MainTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList[collectionView.tag].periodGradeItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "PeriodGradeListItem", bundle: nil), forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 75.0, height: 96.0)
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        collectionCell.layer.cornerRadius = 7.0
        collectionCell.layer.masksToBounds = true
        
        (collectionCell.viewWithTag(1) as! UILabel).text = dataList[collectionView.tag].periodGradeItemArray[indexPath.row].termIndicator
        (collectionCell.viewWithTag(2) as! UILabel).text = dataList[collectionView.tag].periodGradeItemArray[indexPath.row].termLetterGrade
        (collectionCell.viewWithTag(3) as! UILabel).text = dataList[collectionView.tag].periodGradeItemArray[indexPath.row].termPercentageGrade
        collectionCell.backgroundColor = Utils.getColorByPeriodItem(item: dataList[collectionView.tag].periodGradeItemArray[indexPath.row])
        
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
    
    func lighter (by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func darker (by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func adjust (by percentage: CGFloat = 30.0) -> UIColor? {
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor.init(hue: hue - percentage / 100,
                                saturation: saturation + percentage / 100,
                                brightness: brightness + percentage / 100,
                                alpha: alpha)
        } else { return nil }
    }
}

