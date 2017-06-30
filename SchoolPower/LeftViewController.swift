/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presentFragment: Int?
    
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var headerUsername: UILabel?
    @IBOutlet weak var headerUserID: UILabel?
    
    let userDefaults = UserDefaults.standard
    let KEY_NAME = "loggedin"
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        
        table?.delegate = self
        table?.dataSource = self
        table?.separatorColor = UIColor.clear
        table?.contentInset = UIEdgeInsetsMake(16, 0, 0, 0)
        
        headerUsername?.text = "//TODO USERNAME"
        headerUserID?.text = "userid".localize + "//TODO USERID"
    }
    
    func reloadData() {
        table?.reloadData()
    }
    
    func logOut() {
        
        userDefaults.set(false, forKey: KEY_NAME)
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
            default:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "DashboardNav"), duration: 0, options: [], animations: nil, completion: nil)
            }
        } else {
            switch location {
            case 0:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(settingsStory.instantiateViewController(withIdentifier: "Settings"), animated: true)
                
            case 1:
                logOut()
            
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
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerHeaderCell") as! DrawerHeaderCell
            headerCell.categoryStr = "preference".localize
            return headerCell
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 { return 56 }
        else { return 0 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 2
        case 1: return 2
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
