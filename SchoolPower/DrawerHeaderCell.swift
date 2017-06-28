//
//  DrawerHeaderCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-28.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class DrawerHeaderCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var categoryStr = "" {
        didSet {
            categoryTitle.text = categoryStr
        }
    }
}
