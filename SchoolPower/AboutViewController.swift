//
//  AboutViewController.swift
//  SchoolPower
//
//  Created by Gustav Wang on 02/07/2017.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit
import VTAcknowledgementsViewController

class AboutViewController: UITableViewController {
    
    @IBOutlet weak var headerCell: UITableViewCell!
//    @IBOutlet weak var rateCell: UITableViewCell!
//    @IBOutlet weak var donateCell: UITableViewCell!
    @IBOutlet weak var licensesCell: UITableViewCell!
    
    @IBOutlet weak var versionLable: UILabel!
//    @IBOutlet weak var rateLable: UILabel!
//    @IBOutlet weak var donateLable: UILabel!
    @IBOutlet weak var licensesLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "about".localize
        self.tableView.separatorColor = UIColor.clear
        versionLable.text = "version".localize
//        rateLable.text = "rateus".localize
//        donateLable.text = "donateus".localize
        licensesLable.text = "licenses".localize
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
            
//        case 2:
//            switch indexPath.row {
//                
//            case 0:
//                return
//                
//            case 1:
//                return
//                
//            default:
//                return
//            }
            
//        case 3:
        case 2:
            gotoAck()
            
        default:
            return
            
        }
    }
}
