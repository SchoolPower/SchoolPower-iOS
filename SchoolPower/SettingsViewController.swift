//
//  SettingsViewController.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit
import MaterialComponents

class SettingsTableViewController: UITableViewController {
    
    let keySets = ["language", "dashboarddisplays"]
    let titleSets = ["Language", "Dashboard Displays"]
    let descriptionSets = [["System Default", "English", "Chinese"],
                           ["This Term", "This Semester"]]
    
    @IBOutlet weak var languageDetail: UILabel?
    @IBOutlet weak var dspDetail: UILabel?
    
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = Utils().hexStringToUIColor(hex: Colors().primary)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        registerDefaults()
        loadDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func registerDefaults(){
        
        if userDefaults.object(forKey: keySets[0]) == nil {
            userDefaults.register(defaults: [keySets[0]: 0])
        }
        if userDefaults.object(forKey: keySets[1]) == nil {
            userDefaults.register(defaults: [keySets[1]: 1])
        }
        userDefaults.synchronize()
    }
    
    func loadDetails() {
        
        languageDetail?.text = descriptionSets[0][userDefaults.integer(forKey: keySets[0])]
        dspDetail?.text = descriptionSets[1][userDefaults.integer(forKey: keySets[1])]
    }
}

//MARK: Table View
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
