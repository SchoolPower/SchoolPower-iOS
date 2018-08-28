//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class DrawerFragmentCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var background: UIView!
    
    let images = [[#imageLiteral(resourceName: "ic_dashboard_white").withRenderingMode(.alwaysTemplate),
                   #imageLiteral(resourceName: "ic_insert_chart_white").withRenderingMode(.alwaysTemplate),
                   #imageLiteral(resourceName: "ic_beenhere_white").withRenderingMode(.alwaysTemplate)],
                  [#imageLiteral(resourceName: "ic_settings_white").withRenderingMode(.alwaysTemplate),
                   #imageLiteral(resourceName: "ic_star_white").withRenderingMode(.alwaysTemplate),
                   #imageLiteral(resourceName: "ic_info_white").withRenderingMode(.alwaysTemplate),
                   #imageLiteral(resourceName: "ic_exit_to_app_white").withRenderingMode(.alwaysTemplate)]]
    
    var titles = [["dashboard".localize, "charts".localize, "attendance".localize],
                  ["settings".localize, "support_us".localize, "about".localize, "signout".localize]]
    
    var section = 0
    
    var location: Int = 0 {
        
        didSet {
            refreshTitles()
            itemTitle.text = titles[section][location]
            itemImage.image = images[section][location]
        }
    }
    
    var presentSelected = 0 {
        
        didSet{
            
            let theme = ThemeManager.currentTheme()
            background.backgroundColor = .clear
            itemTitle.textColor = theme.secondaryTextColor
            itemImage.tintColor = theme.secondaryTextColor
            if section == 0 && location == presentSelected {
                background.backgroundColor = theme.secondaryTextColor.withAlphaComponent(0.2)
                itemTitle.textColor = Utils.getAccent()
                itemImage.tintColor = Utils.getAccent()
            }
        }
    }
    
    func refreshTitles() {
        titles = [["dashboard".localize, "charts".localize, "attendance".localize],
                  ["settings".localize, "support_us".localize, "about".localize, "signout".localize]]
    }
}
