//
//  Copyright 2018 SchoolPower Studio

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


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
