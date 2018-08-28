//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class SelectSubjectsTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var selectedCourceTitles = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = ThemeManager.currentTheme().windowBackgroundColor
        tableView.separatorColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.3)
        self.title = "select_subjects".localize
        selectedCourceTitles = userDefaults.array(forKey: SELECT_SUBJECTS_KEY_NAME) as! [String]
    }
}

//MARK: Table View
extension SelectSubjectsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSubjectsCell", for: indexPath)
        cell.accessoryType = .none
        if selectedCourceTitles.contains(subjects[indexPath.row].title) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = String.init(format: "(%@%%) %@",
                                           Utils.getLatestItemGrade(grades: subjects[indexPath.row].grades).percentage,
                                           subjects[indexPath.row].title)
        
        cell.textLabel?.textColor = ThemeManager.currentTheme().primaryTextColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        cell?.accessoryType = .none
        
        let title = subjects[indexPath.row].title
        if selectedCourceTitles.contains(title) {
            selectedCourceTitles.remove(at: selectedCourceTitles.index(of: title)!)
        } else {
            selectedCourceTitles.append(title)
            cell?.accessoryType = .checkmark
        }
        
        userDefaults.set(selectedCourceTitles, forKey: SELECT_SUBJECTS_KEY_NAME)
        
    }
}
