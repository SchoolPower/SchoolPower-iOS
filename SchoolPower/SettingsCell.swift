//
//  SettingsCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let userDefaults = UserDefaults.standard
    
    var keySets = [String]()
    var titleSets = [String]()
    var descriptionSets = [[String]]()
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var location = 0 {
        didSet{
            itemTitle.text = titleSets[location]
            itemDescription.text = descriptionSets[location][userDefaults.integer(forKey: keySets[location])]
        }
    }
    
}
