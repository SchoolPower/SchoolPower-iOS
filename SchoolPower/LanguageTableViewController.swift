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
    @IBOutlet weak var itemchit: UITableViewCell?
    @IBOutlet weak var itemchis: UITableViewCell?
    
    @IBOutlet weak var itemdefLable: UILabel?
    
    let LocaleSet = [Locale().initWithLanguageCode(languageCode: Bundle.main.preferredLocalizations.first! as NSString, countryCode: "gb", name: "United Kingdom"), Locale().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom"), Locale().initWithLanguageCode(languageCode: "zh-Hant", countryCode: "cn", name: "China"), Locale().initWithLanguageCode(languageCode: "zh-Hans", countryCode: "cn", name: "China")]
    
    let userDefaults = UserDefaults.standard
    let keyName = "language"
    var languageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageIndex = userDefaults.integer(forKey: keyName)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemdef, itemeng, itemchit, itemchis]
        for item in itemSet {
            item?.accessoryType = .none
            if itemSet.index(where: {$0 === item})! == languageIndex {
                item?.accessoryType = .checkmark
            }
        }
        itemdefLable?.text = "default".localize
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        userDefaults.set(indexPath.row, forKey: keyName)
        userDefaults.synchronize()
        let selectedLang = LocaleSet[indexPath.row]
        DGLocalization.sharedInstance.setLanguage(withCode: selectedLang)
        self.navigationController?.popViewController(animated: true)
    }
}
