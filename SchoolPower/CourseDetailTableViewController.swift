//
//  Copyright 2019 SchoolPower Studio
//

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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationDrawerController?.isLeftViewEnabled = false
        
        self.title = infoItem.title
        
        initTermList()
        setAllTerms()
        self.navigationController?.navigationBar.barTintColor = Utils.getColorByGrade(item: Utils.getLatestItemGrade(grades: infoItem.grades))
        
        NotificationCenter.default.addObserver(self, selector: #selector(setup),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initBannerView()
        setup()
    }
    
    @objc private func setup() {
        
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: bannerView.frame.height, right: 0)
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
    
    func initTermList() {

        for (termName, _) in infoItem.grades{ termsList.append(termName) }
        termsList = Utils.sortTerm(terms: termsList)
        termsList.insert("allterms".localize, at: 0)
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
        headerCell.vc = self
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
        let alert = CustomIOSAlertView(parentView: UIApplication.shared.delegate?.window??.rootViewController?.view ?? self.view)
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
