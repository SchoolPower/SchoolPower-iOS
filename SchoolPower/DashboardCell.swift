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
import FoldingCell

class DashboardCell: FoldingCell {
    
    @IBOutlet weak var foldTeacherName: UILabel!
    @IBOutlet weak var foldBlockLetter: UILabel!
    @IBOutlet weak var foldLetterGrade: UILabel!
    @IBOutlet weak var foldSubjectTitle: UILabel!
    @IBOutlet weak var foldPercentageGrade: UILabel!
    @IBOutlet weak var foldBackground: UIView!
    @IBOutlet weak var foldBorderView: UIView!
    
    @IBOutlet weak var unFoldTeacherName: UILabel!
    @IBOutlet weak var unFoldSubjectTitle: UILabel!
    @IBOutlet weak var unFoldPercentageGrade: UILabel!
    @IBOutlet weak var unfoldBackground: UIView!
    @IBOutlet weak var unfoldBorderView: UIView!
    @IBOutlet weak var periodGradeCollectionView: UICollectionView!
    
    var number: Int = 0 {
        didSet {
            periodGradeCollectionView.tag = number
        }
    }
    
    var infoItem: MainListItem! {
        didSet {
            let periodGradeItem: PeriodGradeItem? = infoItem.getLatestItem()
            foldSubjectTitle.text = infoItem.subjectTitle
            foldTeacherName.text = infoItem.teacherName
            foldBlockLetter.text = "Block " + infoItem.blockLetter
            foldLetterGrade.text = infoItem.getLetterGrade(requiredTerm: periodGradeItem)
            foldPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            unFoldSubjectTitle.text = infoItem.subjectTitle
            unFoldTeacherName.text = infoItem.teacherName
            unFoldPercentageGrade.text = infoItem.getPercentageGrade(requiredTerm: periodGradeItem)
            foldBackground.backgroundColor = Utils.getColorByPeriodItem(item: periodGradeItem!)
            unfoldBackground.backgroundColor = Utils.getColorByPeriodItem(item: periodGradeItem!)
        }
    }
    
    override func awakeFromNib() {
        
        foregroundView.layer.shouldRasterize = true
        foregroundView.layer.rasterizationScale = UIScreen.main.scale
        foregroundView.layer.shadowOffset = CGSize.init(width: 0, height: 2.5)
        foregroundView.layer.shadowRadius = 2
        foregroundView.layer.shadowOpacity = 0.2
        foregroundView.layer.backgroundColor = UIColor.clear.cgColor
        
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        containerView.layer.shadowOffset = CGSize.init(width: 0, height: 2.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.backgroundColor = UIColor.clear.cgColor
        
        foldBorderView.layer.cornerRadius = 10
        foldBorderView.layer.masksToBounds = true
        unfoldBorderView.layer.cornerRadius = 10
        unfoldBorderView.layer.masksToBounds = true
        
        
        
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
