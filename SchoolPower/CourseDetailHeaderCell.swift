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
        
        assignments?.text = "assignments".localize
        super.awakeFromNib()
    }
    
    var infoItem: Subject! {
        
        didSet {
            let grade = Utils.getLatestItemGrade(grades: infoItem.grades)
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
                self.tracherEmail = infoItem.teacherEmail
            }
        }
    }
    
    @IBAction func emailOnclick(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.viewController()?.present(mailComposeViewController, animated: true, completion: nil)
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
