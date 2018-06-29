//
//  Copyright 2018 SchoolPower Studio

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
import Material
import VTAcknowledgementsViewController

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presentFragment: Int?
    
    @IBOutlet weak var viewBackground: UIView?
    @IBOutlet weak var headerBackground: UIView?
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var headerUsername: UILabel?
    @IBOutlet weak var headerUserID: UILabel?
    
    let userDefaults = UserDefaults.standard
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        
        let theme = ThemeManager.currentTheme()
        
        headerBackground?.backgroundColor = theme.primaryColor
        viewBackground?.backgroundColor = theme.primaryColor
        
        table?.delegate = self
        table?.dataSource = self
        table?.separatorColor = theme.windowBackgroundColor
        table?.contentInset = UIEdgeInsetsMake(16, 0, 0, 0)
        table?.backgroundColor = theme.windowBackgroundColor
        
        headerUsername?.text = userDefaults.string(forKey: STUDENT_NAME_KEY_NAME)
        headerUserID?.text = "userid".localize + userDefaults.string(forKey: USERNAME_KEY_NAME)!
    }
    
    func reloadData() {
        setup()
        table?.reloadData()
    }
    
    func confirmLogOut() {
        
        let alert = UIAlertController.init(title: "logging_out".localize, message: "sure_to_log_out".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "logout".localize, style: .destructive) { (action:UIAlertAction!) in
            self.logOut()
        })
        alert.addAction(UIAlertAction.init(title: "dont".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func logOut() {
        
        userDefaults.set(false, forKey: LOGGED_IN_KEY_NAME)
        Utils.saveHistoryGrade(data: nil)
        Utils.saveStringToFile(filename: JSON_FILE_NAME, data: "")
        startLoginController()
    }
    
    func startLoginController() {
        
        UIApplication.shared.delegate?.window??.rootViewController!.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login"), animated: true, completion: updateRootViewController)
    }
    
    func updateRootViewController() {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let loginController = story.instantiateViewController(withIdentifier: "login")
        UIApplication.shared.delegate?.window??.rootViewController = loginController
    }
}

//MARK: Drawer
extension LeftViewController {
    @objc
    func gotoFragment(section: Int, location: Int) {
        
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let settingsStory = UIStoryboard(name: "Settings", bundle: nil)
        
        if section == 0 {
            switch location {
                
            case 0:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "DashboardNav"), duration: 0, options: [], animations: nil, completion: nil)
            case 1:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "ChartsNav"), duration: 0, options: [], animations: nil, completion: nil)
            case 2:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "AttendanceNav"), duration: 0, options: [], animations: nil, completion: nil)
            default:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "DashboardNav"), duration: 0, options: [], animations: nil, completion: nil)
            }
            
        } else {
            switch location {
                
            case 0:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(settingsStory.instantiateViewController(withIdentifier: "Settings"), animated: true)
            case 1:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(mainStory.instantiateViewController(withIdentifier: "Support Us"), animated: true)
            case 2:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(mainStory.instantiateViewController(withIdentifier: "About"), animated: true)
            case 3:
                confirmLogOut()
            
            default:
                print("NoViewToGoTo")
            }
        }
        closeNavigationDrawer()
    }
    
    public func closeNavigationDrawer() {
        navigationDrawerController?.closeLeftView()
    }
}

//MARK: Table View
extension LeftViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerHeaderCell")
            headerCell?.contentView.viewWithTag(1)?
                .backgroundColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.5)
            return headerCell
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 { return 20 }
        else { return 0 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 3
        case 1: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerFragmentCell", for: indexPath) as! DrawerFragmentCell
        cell.section = indexPath.section
        cell.location = indexPath.row
        cell.presentSelected = presentFragment ?? 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! DrawerFragmentCell
        cell.isSelected = false
        if cell.section == 0 {
            presentFragment = cell.location
            tableView.reloadData()
        }
        gotoFragment(section: cell.section, location: cell.location)
    }
}
