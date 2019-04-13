//
//  Copyright 2019 SchoolPower Studio
//

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
    @IBOutlet weak var joinFeedbackQQGroupTitle: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "about".localize
        self.tableView.separatorColor = .clear
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: Colors.primary)
        self.tableView.backgroundColor = UIColor(rgb: Colors.primary_dark)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        self.navigationDrawerController?.isLeftViewEnabled = false
        
        versionLable.text = "version".localize
        licensesLable.text = "licenses".localize
        reportBugTitle?.text = "report_bug".localize
        visitWebsiteTitle?.text = "visit_website".localize
        getSourceCodeTitle?.text = "source_code".localize
        joinFeedbackQQGroupTitle?.text = "join_feedback_qq_group".localize
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
            case 2:
                UIApplication.shared.openURL(NSURL(string: CODE_URL)! as URL)
                break
            case 3:
                UIApplication.shared.openURL(NSURL(string: QQ_GROUP_URL)! as URL)
                break
            default:
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
