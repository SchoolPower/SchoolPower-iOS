//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class CalculateRuleTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var itemAll: UITableViewCell?
    @IBOutlet weak var itemHighest3: UITableViewCell?
    @IBOutlet weak var itemHighest4: UITableViewCell?
    @IBOutlet weak var itemHighest5: UITableViewCell?
    
    @IBOutlet weak var itemAllLabel: UILabel?
    @IBOutlet weak var itemHighest3Label: UILabel?
    @IBOutlet weak var itemHighest4Label: UILabel?
    @IBOutlet weak var itemHighest5Label: UILabel?
    
    var ruleIndex: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.3)
        self.title = "calculate_rule".localize
        ruleIndex = userDefaults.integer(forKey: CALCULATE_RULE_KEY_NAME)
        loadCells()
    }
    
    func loadCells() {
        
        let itemSet = [itemAll, itemHighest3, itemHighest4, itemHighest5]
        for item in itemSet {
            item?.accessoryType = .none
            item?.textLabel?.textColor = ThemeManager.currentTheme().primaryTextColor
            if itemSet.index(where: {$0 === item})! == ruleIndex { item?.accessoryType = .checkmark }
        }
        itemAllLabel?.text = CUSTOM_RULES[0].localize
        itemHighest3Label?.text = CUSTOM_RULES[1].localize
        itemHighest4Label?.text = CUSTOM_RULES[2].localize
        itemHighest5Label?.text = CUSTOM_RULES[3].localize
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        userDefaults.set(indexPath.row, forKey: CALCULATE_RULE_KEY_NAME)
        
        
        self.navigationController?.popViewController(animated: true)
    }
}
