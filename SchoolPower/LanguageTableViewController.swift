//
//  LanguageTableViewController.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {
    
    @IBOutlet weak var itemdef: UITableViewCell?
    @IBOutlet weak var itemeng: UITableViewCell?
    @IBOutlet weak var itemchi: UITableViewCell?
    
    let userDefaults = UserDefaults.standard
    let keyName = "language"
    var languageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemdef, itemeng, itemchi]
        for item in itemSet {
            item?.accessoryType = .none
            if itemSet.index(where: {$0 === item})! == languageIndex {
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
