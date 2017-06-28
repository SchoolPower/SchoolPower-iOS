//
//  MainTableViewController.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-21.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import UIKit
import MaterialComponents
import Material
import FoldingCell

struct ButtonLayout {
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
}

class MainTableViewController: UITableViewController {
    
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    let kOpenCellHeight: CGFloat = 315
    let kCloseCellHeight: CGFloat = 125
    var storedOffsets = [Int: CGFloat]()
    
    let dataList: Array<MainListItem> =
        [MainListItem(_subjectTitle: "Foundation of Mathematics and Pre-Calculus 10", _teacherName: "Susan Holcapek", _blockLetter: "A", _roomNumber: "311", _periodGradeItemArray: [
            PeriodGradeItem(_termIndicator: "T3", _termLetterGrade: "F", _termPercentageGrade: "10",                                                                                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS1", _assignmentDate: "6/4", _assignmentPercentage: "10", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")]),
            PeriodGradeItem(_termIndicator: "T4", _termLetterGrade: "F", _termPercentageGrade: "10",
                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS2", _assignmentDate: "6/4", _assignmentPercentage: "100", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")]),
            PeriodGradeItem(_termIndicator: "S2", _termLetterGrade: "F", _termPercentageGrade: "10",
                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS3", _assignmentDate: "6/4", _assignmentPercentage: "100", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")])]),
         MainListItem(_subjectTitle: "Planning 10", _teacherName: "Grainne Smith", _blockLetter: "B", _roomNumber: "311", _periodGradeItemArray: [
            PeriodGradeItem(_termIndicator: "T1", _termLetterGrade: "A", _termPercentageGrade: "10",                                                                                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS1", _assignmentDate: "6/4", _assignmentPercentage: "10", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")]),
            PeriodGradeItem(_termIndicator: "T2", _termLetterGrade: "C+", _termPercentageGrade: "73",
                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS2", _assignmentDate: "6/4", _assignmentPercentage: "10", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")]),
            PeriodGradeItem(_termIndicator: "S2", _termLetterGrade: "C-", _termPercentageGrade: "55",
                            _assignmentItemArrayList: [AssignmentItem(_assignmentTitle: "ASS2", _assignmentDate: "6/4", _assignmentPercentage: "10", _assignmentDividedScore: "1/1", _assignmentGrade: "A", _assignmentCategory: "CAT", _assignmentTerm: "T1")])])]
    
    override func viewWillAppear(_ animated: Bool) {
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white")?.withRenderingMode(.alwaysOriginal) , style: .plain ,target: self, action: #selector(menuOnClick))
        let gpaItem = UIBarButtonItem(image: UIImage(named: "ic_grade_white")?.withRenderingMode(.alwaysOriginal) , style: .plain ,target: self, action: #selector(gpaOnClick))

        self.navigationItem.leftBarButtonItems = [menuItem]
        self.navigationItem.rightBarButtonItems = [gpaItem]
        
        self.navigationController?.navigationBar.barTintColor = Utils().hexStringToUIColor(hex: Colors().primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = Utils().hexStringToUIColor(hex: Colors().foreground_material_dark)
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
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
        button.backgroundColor = Utils().hexStringToUIColor(hex: Colors().accent)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(MainTableViewController.fabOnClick), for: .touchUpInside)
        cell.containerView.addSubview(button)
        
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 60)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell.containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -10)
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: cell.containerView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -55)
        
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
    
    func menuOnClick(sender: UINavigationItem) {
        
        navigationDrawerController?.toggleLeftView()
    }
    
    func gpaOnClick(sender: UINavigationItem) {
        //TODO GPA
    }
    
    func fabOnClick(sender: UIButton) {
        
        performSegue(withIdentifier: "gotoDetail", sender: sender)
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
        return dataList[1].periodGradeItemArray.count
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
        collectionCell.backgroundColor = Utils().getColorByPeriodItem(item: dataList[collectionView.tag].periodGradeItemArray[indexPath.row])
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}

