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

var dataList = [MainListItem]()

class MainTableViewController: UITableViewController {
    
    var bannerView: GADBannerView!
    
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
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.title = "dashboard".localize
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initValue()
    }
    
    func initValue() {
        
        let input = Utils.readDataArrayList()
        if input != nil { dataList = input! }
        initDataJson()
        initUI()
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
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(20, 0, bannerView.frame.height, 0)
    }
    
    func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
        (navigationDrawerController?.leftViewController as! LeftViewController).reloadData()
    }

    func gpaOnClick(sender: UINavigationItem) {

        var sum_gpa=0.0
        var gpa_except_hr=0.0
        var gpa_except_hr_me=0.0
        var num=0
        for subject in dataList {
            if let period = subject.getLatestItem() {
                let grade = Double(period.termPercentageGrade)!
                sum_gpa+=grade
                num+=1
                if subject.subjectTitle.contains("Homeroom") { continue }
                gpa_except_hr+=grade
                if subject.subjectTitle.contains("Moral Education") { continue }
                gpa_except_hr_me+=grade
            }
        }
        let doubleNum = Double(num)
        let alert = UIAlertController(title: "GPA", message: String(format: "gpamessage".localize, dataList[0].getLatestItem()!.termIndicator, sum_gpa/doubleNum, gpa_except_hr/(doubleNum-1), gpa_except_hr_me/(doubleNum-2)), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fabOnClick(sender: UIButton) {
        performSegue(withIdentifier: "gotoDetail", sender: sender)
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
            let messages = response.components(separatedBy: "\n")
            
            if !response.contains("assignments") { return }
            
            if response.contains("{\"error\":1,\"") {
                self.showSnackbar(msg: "invalidup".localize)
                self.logOut()
            } else if response.contains("[{\"") {
                
                if messages.count == 3 && !messages[1].isEmpty {
                    
                    let jsonStr = messages[1]
                    Utils.saveStringToFile(filename: self.JSON_FILE_NAME, data:  jsonStr)
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
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    self.showSnackbar(msg: "data_updated".localize)
                    
                } else { self.showSnackbar(msg: "cannot_connect".localize) }
            }
        }
    }
    
    func logOut() {
        
        userDefaults.set(false, forKey: KEY_NAME)
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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? DashboardCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
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
        if cell.isAnimating() { return }
        
        let button = FABButton(image: UIImage(named: "ic_keyboard_arrow_right_white_36pt"), tintColor: UIColor.white)
        button.pulseColor = UIColor.white
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

