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
import VTAcknowledgementsViewController

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var licensesCell: UITableViewCell!
    
    @IBOutlet weak var versionLable: UILabel!
    @IBOutlet weak var licensesLable: UILabel!
    @IBOutlet weak var reportBugTitle: UILabel!
    @IBOutlet weak var reportBugDetail: UILabel!
    @IBOutlet weak var visitWebsiteTitle: UILabel!
    @IBOutlet weak var getSourceCodeTitle: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "about".localize
        self.tableView.separatorColor = .clear
        
        versionLable.text = "version".localize
        licensesLable.text = "licenses".localize
        reportBugTitle?.text = "report_bug".localize
        visitWebsiteTitle?.text = "visit_website".localize
        getSourceCodeTitle?.text = "source_code".localize
        reportBugDetail?.text = "report_bug_summary".localize
        
        versionLabel?.text =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    func gotoAck() {
        
        let ackViewController = VTAcknowledgementsViewController.init(fileNamed: "Pods-SchoolPower-acknowledgements")
        ackViewController?.title = "licenses".localize
        ackViewController?.headerText = "iloveopensource".localize
        (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(ackViewController!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
                
            case 0:
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
                break
            case 1:
                UIApplication.shared.openURL(NSURL(string: WEBSITE_URL)! as URL)
                break
            default:
                UIApplication.shared.openURL(NSURL(string: CODE_URL)! as URL)
                break
            }
        case 3:
            gotoAck()
            break
        default:
            break
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let version = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([SUPPORT_EMAIL])
        mailComposerVC.setSubject("bug_report_email_subject".localize)
        mailComposerVC.setMessageBody(String(format: "bug_report_email_content".localize, version), isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
