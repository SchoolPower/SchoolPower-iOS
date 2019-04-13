//
//  Copyright 2019 SchoolPower Studio
//

import UIKit
import MessageUI

class CourseDetailHeaderCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var headerTeacherName: UILabel!
    @IBOutlet weak var headerBlockLetter: UILabel!
    @IBOutlet weak var headerRoomNumber: UILabel!
    @IBOutlet weak var headerPercentageGrade: UILabel!
    @IBOutlet weak var headerLetterGrade: UILabel!
    @IBOutlet weak var foreBackground: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var leftBackground: UIView!
    @IBOutlet weak var assignments: UILabel?
    @IBOutlet weak var termLable: UILabel!
    @IBOutlet weak var chooseIcon: UIImageView!
    @IBOutlet weak var emailButton: UIButton!
    
    var tracherEmail = ""
    
    override func awakeFromNib() {
        
        foreBackground.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        foreBackground.layer.shadowRadius = 2
        foreBackground.layer.shadowOpacity = 0.2
        foreBackground.layer.backgroundColor = UIColor.clear.cgColor
        
        foreground.layer.cornerRadius = 10
        foreground.layer.masksToBounds = true
        foreground.layer.backgroundColor = ThemeManager.currentTheme().cardBackgroundColor.cgColor
        
        assignments?.text = "assignments".localize
        assignments?.textColor = ThemeManager.currentTheme().primaryTextColor
        
        super.awakeFromNib()
    }
    
    var infoItem: Subject! {
        
        didSet {
            let grade = Utils.getLatestItemGrade(grades: infoItem.grades)
            
            let theme = ThemeManager.currentTheme()
            headerTeacherName.textColor = theme.primaryTextColor
            headerBlockLetter.textColor = theme.secondaryTextColor
            headerRoomNumber.textColor = theme.secondaryTextColor
            termLable.textColor = theme.primaryTextColor
            chooseIcon.tintColor = theme.primaryTextColor
            
            headerTeacherName.text = infoItem.teacherName
            headerBlockLetter.text = "Block " + infoItem.blockLetter
            headerRoomNumber.text = "room".localize + infoItem.roomNumber
            headerPercentageGrade.text = grade.percentage
            headerLetterGrade.text = grade.letter
            leftBackground.backgroundColor = Utils.getColorByGrade(item: grade)
            if infoItem.teacherEmail == "" {
                emailButton.width = 0
                emailButton.isHidden = true
            } else {
                emailButton.tintColor = theme.primaryTextColor.withAlphaComponent(0.2)
                self.tracherEmail = infoItem.teacherEmail
            }
        }
    }
    
    var vc: UIViewController!
    
    @IBAction func emailOnclick(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.vc.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([self.tracherEmail])
        
        return mailComposerVC
    }
    
    var currentTerm = "allterms".localize {
        
        didSet {
            termLable?.text = currentTerm
        }
    }
}
