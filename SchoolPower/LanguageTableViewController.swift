//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class LanguageTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var itemdef: UITableViewCell?
    @IBOutlet weak var itemeng: UITableViewCell?
    @IBOutlet weak var itemchit: UITableViewCell?
    @IBOutlet weak var itemchis: UITableViewCell?
    @IBOutlet weak var itemdefLable: UILabel?
  
    var languageIndex: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.3)
        self.title = "language".localize
        languageIndex = userDefaults.integer(forKey: LANGUAGE_KEY_NAME)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemdef, itemeng, itemchit, itemchis]
        for item in itemSet {
            item?.accessoryType = .none
            item?.textLabel?.textColor = ThemeManager.currentTheme().primaryTextColor
            if itemSet.index(where: {$0 === item})! == languageIndex { item?.accessoryType = .checkmark }
        }
        itemdefLable?.text = "default".localize
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        userDefaults.set(indexPath.row, forKey: LANGUAGE_KEY_NAME)
        
        let selectedLang = LOCALE_SET[indexPath.row]
        DGLocalization.sharedInstance.setLanguage(withCode: selectedLang)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLanguage"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
