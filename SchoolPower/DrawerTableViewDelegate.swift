//
//  DrawerTableViewDelegate.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DrawerTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 1) {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerHeaderCell") as! DrawerHeaderCell
            headerCell.categoryStr = "Preference"
            return headerCell
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 1) {
            return 56
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
