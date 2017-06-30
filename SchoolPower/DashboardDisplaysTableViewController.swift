//
//  DashboardDisplaysTableViewController.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DashboardDisplaysTableViewController: UITableViewController {

    @IBOutlet weak var itemTermTitle: UILabel?
    @IBOutlet weak var itemSemesterTitle: UILabel?
    @IBOutlet weak var itemTerm: UITableViewCell?
    @IBOutlet weak var itemSemester: UITableViewCell?
    
    let userDefaults = UserDefaults.standard
    let keyName = "dashboarddisplays"
    var dspIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dspIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        itemTermTitle?.text = "the_score_of_this_term".localize
        itemSemesterTitle?.text = "the_score_of_this_semester".localize
        
        let itemSet = [itemTerm, itemSemester]
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
