//
//  Copyright 2017 SchoolPower Studio

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

class DrawerFragmentCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var background: UIView!
    
    let images = [[UIImage(named: "ic_dashboard_white")?.withRenderingMode(.alwaysTemplate),
                   UIImage(named: "ic_insert_chart_white")?.withRenderingMode(.alwaysTemplate)],
                  [UIImage(named: "ic_settings_white")?.withRenderingMode(.alwaysTemplate),
                   UIImage(named: "ic_info_white")?.withRenderingMode(.alwaysTemplate),
                   UIImage(named: "ic_exit_to_app_white")?.withRenderingMode(.alwaysTemplate)]]
    
    var section = 0
    
    var location: Int = 0 {
        
        didSet {
            itemTitle.text = [["dashboard".localize, "charts".localize],
                              ["settings".localize, "about".localize, "signout".localize]][section][location]
            itemImage.image = images[section][location]
        }
    }
    
    var presentSelected = 0 {
        
        didSet{
            background.backgroundColor = UIColor.clear
            if section == 0 && location == presentSelected {
                background.backgroundColor = UIColor(rgb: Colors.foreground_material_dark)
            }
        }
    }
}
