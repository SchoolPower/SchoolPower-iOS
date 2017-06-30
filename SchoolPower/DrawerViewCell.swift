//
//  DrawerViewCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DrawerFragmentCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var background: UIView!
    
    let images = [[UIImage(named: "ic_dashboard_white")?.withRenderingMode(.alwaysTemplate),
                   UIImage(named: "ic_insert_chart_white")?.withRenderingMode(.alwaysTemplate)],
                  [UIImage(named: "ic_settings_white")?.withRenderingMode(.alwaysTemplate),
                   UIImage(named: "ic_exit_to_app_white")?.withRenderingMode(.alwaysTemplate),]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var section = 0
    var location: Int = 0 {
        didSet {
            itemTitle.text = [["dashboard".localize, "charts".localize],
                              ["settings".localize, "signout".localize]][section][location]
            itemImage.image = images[section][location]
        }
    }
    var presentSelected = 0 {
        didSet{
            background.backgroundColor = UIColor.clear
            if section == 0 && location == presentSelected {
                background.backgroundColor = Utils().hexStringToUIColor(hex: Colors().foreground_material_dark)
            }
        }
    }
}
