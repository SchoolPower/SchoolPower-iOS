//
//  DashboardDisplaysTableViewController.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DashboardDisplaysTableViewController: UITableViewController {

    @IBOutlet weak var itemterm: UITableViewCell?
    @IBOutlet weak var itemsemester: UITableViewCell?
    
    let userDefaults = UserDefaults.standard
    let keyName = "dashboarddisplays"
    var dspIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dspIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemterm, itemsemester]
        for item in itemSet {
            item?.accessoryType = .none
            if itemSet.index(where: {$0 === item})! == dspIndex {
                item?.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        userDefaults.set(indexPath.row, forKey: keyName)
        userDefaults.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
}
