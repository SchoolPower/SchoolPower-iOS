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
import GoogleMobileAds
import ActionSheetPicker_3_0

class CourseDetailTableViewController: UITableViewController {
    
    var currentTerm = 0
    var infoItem: MainListItem!
    var bannerView: GADBannerView!
    var termsList: Array<String> = Array()
    var list: Array<AssignmentItem> = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = infoItem.subjectTitle
        
        initTermList()
        setAllTerms(termsList: termsList)
        self.navigationController?.navigationBar.barTintColor = Utils.getColorByPeriodItem(item: infoItem.getLatestItem()!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        initBannerView()
        tableView.backgroundColor = UIColor(rgb: Colors.foreground_material_dark)
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(20, 0, bannerView.frame.height, 0)
    }
    
    func initBannerView() {
        
        bannerView = GADBannerView(adSize: GADAdSize.init(size: CGSize.init(width: 320, height: 50), flags: 0))
        bannerView.frame = CGRect.init(x: (self.view.frame.size.width - 320) / 2, y: self.view.frame.size.height - 50, width: 320, height: 50)
        
        self.view.addSubview(bannerView)
        let horizontalConstraint = NSLayoutConstraint(item: bannerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([horizontalConstraint])
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func initTermList() {
        
        let periodGradeItemList = infoItem.periodGradeItemArray
        termsList.append("allterms".localize)
        for i in periodGradeItemList.indices{ termsList.append(periodGradeItemList[i].termIndicator) }
    }
    
    func setAllTerms(termsList: Array<String>) {
        
        if termsList.contains("Y1") {setTerm(term: "Y1")}
        else if termsList.contains("S1") {setTerm(term: "S1")}
        else if termsList.contains("S2") {setTerm(term: "S2")}
        else {setTerm(term: termsList[1])}
    }
    
    
    func setTerm(term: String) {
        
        list = infoItem.getAssignmentItemArray(term: term)!
    }
    
    @IBAction func ChooseTermOnClick(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "selectterm".localize, rows: termsList, initialSelection: currentTerm, doneBlock: {
            picker, value, index in
            
            self.currentTerm = value
            if value == 0 { self.setAllTerms(termsList: self.termsList) }
            else {self.setTerm(term: self.termsList[value])}
            self.tableView.reloadData()
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.tableView)
    }
}

//MARK: Table View
extension CourseDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailHeaderCell") as! CourseDetailHeaderCell
        headerCell.infoItem = infoItem
        headerCell.currentTerm = termsList[currentTerm]
        headerCell.backgroundColor = UIColor.clear
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 133
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "CourseDetailFooterCell")
        footerCell?.backgroundColor = UIColor.clear
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (list.isEmpty) {return 0}
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath) as! AssignmentCell
        return cell
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
        cell.list = list
    }
    
}
