//
//  DrawerHeaderView.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DrawerHeaderView: UITableViewCell {

    @IBOutlet weak var headerUsername: UILabel!
    @IBOutlet weak var headerUserID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var username = "" {
        didSet {
            headerUsername.text = username
        }
    }
    
    var userID = "" {
        didSet {
            headerUserID.text = "User ID: " + userID
        }
    }
}
