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
        self.tableView.separatorColor = .clear
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
