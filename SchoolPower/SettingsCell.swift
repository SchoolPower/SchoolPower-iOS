//
//  Copyright 2019 SchoolPower Studio
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!

    var keySets = [String]()
    var titleSets = [String]()
    var descriptionSets = [[String]]()
    
    var location = 0 {
        
        didSet{
            itemTitle.text = titleSets[location]
            itemDescription.text = descriptionSets[location][userDefaults.integer(forKey: keySets[location])]
        }
    }
}
