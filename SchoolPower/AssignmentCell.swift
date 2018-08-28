//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class AssignmentCell: UITableViewCell {
    
    var location: Int = 0
    
    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var assignmentDate: UILabel!
    @IBOutlet weak var assignmentPercentageGrade: UILabel!
    @IBOutlet weak var assignmentDividedGrade: UILabel!
    @IBOutlet weak var gradeBackground: UIView!
    @IBOutlet weak var foreBackground: UIView!
    @IBOutlet weak var foregroundBroader: UIView!
    @IBOutlet weak var flagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        foreBackground.layer.shouldRasterize = true
        foreBackground.layer.rasterizationScale = UIScreen.main.scale
        foreBackground.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        foreBackground.layer.shadowRadius = 1
        foreBackground.layer.shadowOpacity = 0.2
        foreBackground.layer.backgroundColor = UIColor.clear.cgColor
        
        foregroundBroader.layer.cornerRadius = 10
        foregroundBroader.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    var assignments: Array<Assignment>! {
        
        didSet {
            let sortedList = assignments.sorted(by: {$0.date > $1.date})
            let assignmentItem = sortedList[location]
            let theme = ThemeManager.currentTheme()
            
            assignmentTitle.text = assignmentItem.title
            assignmentDate.text = assignmentItem.date
            assignmentPercentageGrade.text = assignmentItem.percentage
            assignmentDividedGrade.text = assignmentItem.getDividedScore()
            gradeBackground.backgroundColor = Utils.getColorByLetterGrade(letterGrade: assignmentItem.letterGrade)
            
            if assignmentItem.isNew {
                foregroundBroader.backgroundColor = Utils.getAccent()
                assignmentTitle.textColor = .white
                assignmentDate.textColor = UIColor(rgb: Int(Colors.white_0_20))
            } else {
                foregroundBroader.backgroundColor = ThemeManager.currentTheme().cardBackgroundColor
                assignmentTitle.textColor = theme.primaryTextColor
                assignmentDate.textColor = theme.secondaryTextColor
            }
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        flagCollectionView.delegate = dataSourceDelegate
        flagCollectionView.dataSource = dataSourceDelegate
        flagCollectionView.tag = row
        flagCollectionView.isUserInteractionEnabled = false
        flagCollectionView.setContentOffset(flagCollectionView.contentOffset, animated:false)
        flagCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        
        set { flagCollectionView.contentOffset.x = newValue }
        get { return flagCollectionView.contentOffset.x }
    }
}
