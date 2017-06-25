//
//  DashboardCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-21.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import UIKit

class DashboardCell: FoldingCell {
    
    @IBOutlet weak var foldTeacherName: UILabel!
    @IBOutlet weak var foldBlockLetter: UILabel!
    @IBOutlet weak var foldLetterGrade: UILabel!
    @IBOutlet weak var foldSubjectTitle: UILabel!
    @IBOutlet weak var foldPercentageGrade: UILabel!
    @IBOutlet weak var foldBackground: UIView!
    
    @IBOutlet weak var unFoldTeacherName: UILabel!
    @IBOutlet weak var unFoldSubjectTitle: UILabel!
    @IBOutlet weak var unFoldPercentageGrade: UILabel!
    @IBOutlet weak var unfoldBackground: UIView!
    @IBOutlet weak var periodGradeCollectionView: UICollectionView!
    
    var number: Int = 0 {
        didSet {
            periodGradeCollectionView.tag = number
        }
    }
    
    var infoItem: MainListItem! {
        didSet {
            let periodGradeItem: PeriodGradeItem? = Utils().getLatestItem(item: infoItem)
            foldSubjectTitle.text = infoItem.subjectTitle
            foldTeacherName.text = infoItem.teacherName
            foldBlockLetter.text = "Block " + infoItem.blockLetter
            foldLetterGrade.text = infoItem.getLetterGrade(requiredTerm: periodGradeItem)
            foldPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            unFoldSubjectTitle.text = infoItem.subjectTitle
            unFoldTeacherName.text = infoItem.teacherName
            unFoldPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            foldBackground.backgroundColor = Utils().getColorByPeriodItem(item: periodGradeItem!)
            unfoldBackground.backgroundColor = Utils().getColorByPeriodItem(item: periodGradeItem!)
        }
    }
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}


// MARK: - Actions
extension DashboardCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        periodGradeCollectionView.delegate = dataSourceDelegate
        periodGradeCollectionView.dataSource = dataSourceDelegate
        periodGradeCollectionView.tag = row
        periodGradeCollectionView.setContentOffset(periodGradeCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        periodGradeCollectionView.reloadData()
    }
    
    
    var collectionViewOffset: CGFloat {
        set { periodGradeCollectionView.contentOffset.x = newValue }
        get { return periodGradeCollectionView.contentOffset.x }
    }

}
