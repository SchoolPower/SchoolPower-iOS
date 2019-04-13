//
//  Copyright 2019 SchoolPower Studio
//

import UIKit

class DashboardDisplaysTableViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var itemTermTitle: UILabel?
    @IBOutlet weak var itemSemesterTitle: UILabel?
    @IBOutlet weak var itemTerm: UITableViewCell?
    @IBOutlet weak var itemSemester: UITableViewCell?
    
    var dspIndex: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.3)
        self.title = "dashboardDisplays".localize
        dspIndex = userDefaults.integer(forKey: DASHBOARD_DISPLAY_KEY_NAME)
        loadCells()
    }
    
    func loadCells() {
        
        itemTermTitle?.text = "the_score_of_this_term".localize
        itemSemesterTitle?.text = "the_score_of_this_semester".localize
        
        let itemSet = [itemTerm, itemSemester]
        for item in itemSet {
            item?.accessoryType = .none
            item?.textLabel?.textColor = ThemeManager.currentTheme().primaryTextColor
            if itemSet.index(where: {$0 === item})! == dspIndex { item?.accessoryType = .checkmark }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        userDefaults.set(indexPath.row, forKey: DASHBOARD_DISPLAY_KEY_NAME)
        
        
        self.navigationController?.popViewController(animated: true)
    }
}
