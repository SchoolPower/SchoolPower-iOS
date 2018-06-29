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
import GoogleMobileAds
import CustomIOSAlertView
import ActionSheetPicker_3_0

class CourseDetailTableViewController: UITableViewController {
    
    var currentTerm = 0
    var infoItem: Subject!
    var bannerView: GADBannerView!
    var termsList: Array<String> = Array()
    var list: [Assignment] = Array()
    var storedOffsets = [Int: CGFloat]()
    
    fileprivate var flags: [(key: String, value: Bool)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationDrawerController?.isLeftViewEnabled = false
        
        self.title = infoItem.title
        
        initTermList()
        setAllTerms()
        self.navigationController?.navigationBar.barTintColor = Utils.getColorByGrade(item: Utils.getLatestItemGrade(grades: infoItem.grades))
        
        //TODO: SETUP WHEN THEME CHANGED
        setup()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initBannerView()
        setup()
    }
    
    private func setup() {
        
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsetsMake(20, 0, bannerView.frame.height, 0)
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
        bannerView.adUnitID = "ca-app-pub-9841217337381410/4059063088"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func initTermList() {

        termsList.append("allterms".localize)
        for (termName, _) in infoItem.grades{ termsList.append(termName) }
    }
    
    func setAllTerms() {
        setTerm(term: "ANY")
    }
    
    func setTerm(term: String) {
        if term=="ANY"{
            list = infoItem.assignments
            return
        }
        list = [Assignment]()
        for assignment in infoItem.assignments{
            if assignment.terms.contains(term){
                list.append(assignment)
            }
        }
    }
    
    @IBAction func ChooseTermOnClick(_ sender: Any) {
        
        let picker = ActionSheetStringPicker.init(title: "selectterm".localize, rows: termsList,
                initialSelection: currentTerm, doneBlock: {
            picker, value, index in
            
            self.currentTerm = value
            if value == 0 { self.setAllTerms() }
            else {self.setTerm(term: self.termsList[value])}
            self.tableView.reloadData()
            return
                    
        }, cancel: { ActionStringCancelBlock in return }, origin: self.tableView)
        
        let cancelButton = UIBarButtonItem()
        let doneButton = UIBarButtonItem()
        cancelButton.title = "cancel".localize
        doneButton.title = "done".localize
        picker?.setCancelButton(cancelButton)
        picker?.setDoneButton(doneButton)
        picker?.show()
    }
}

//MARK: Table View
extension CourseDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailHeaderCell") as! CourseDetailHeaderCell
        headerCell.infoItem = infoItem
        headerCell.currentTerm = termsList[currentTerm]
        headerCell.backgroundColor = .clear
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 133
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailFooterCell")
        footerCell?.backgroundColor = .clear
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath) as! AssignmentCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var bannerFrame = self.bannerView.frame
        bannerFrame.origin.y = self.view.frame.size.height - 50 + self.tableView.contentOffset.y
        self.bannerView.frame = bannerFrame
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as AssignmentCell = cell else { return }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.location = indexPath.row
        cell.assignments = list
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? AssignmentCell else {
            return
        }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    //MARK: ASSIGNMENT ONCLICK, SHOW ASSIGNMENT DIALOG
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let standerdWidth = self.view.frame.width * 0.8
        let alert = CustomIOSAlertView.init()
        let assignmentDialog = AssignmentDialog.instanceFromNib(
            width: standerdWidth,
            subject: infoItem.title,
            assignment: list.sorted(by: {$0.date > $1.date})[indexPath.row])
        
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: assignmentDialog.bounds.size.height))
        assignmentDialog.center = subview.center
        subview.addSubview(assignmentDialog)
        alert?.containerView = subview
        alert?.closeOnTouchUpOutside = true
        alert?.buttonTitles = nil
        alert?.show()
    }
    
}

//MARK: Collection View
extension CourseDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.sorted(by: {$0.date > $1.date})[collectionView.tag].trueFlags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: "AssignmentFlagCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 15.0, height: 15.0)
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let (icon, _) = Utils.getAssignmentFlagIconAndDescripWithKey(key: list.sorted(by: {$0.date > $1.date})[collectionView.tag].trueFlags[indexPath.row].key)
        (collectionCell.viewWithTag(1) as! UIImageView).image = icon
        collectionCell.backgroundColor = .clear
        
        return collectionCell
    }
}
