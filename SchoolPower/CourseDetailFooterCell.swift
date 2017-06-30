//
//  CourseDetailFooterCell.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-06-30.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class CourseDetailFooterCell: UITableViewCell {
    
    @IBOutlet weak var theEnd: UILabel?
    
    override func awakeFromNib() {
        
        theEnd?.text = "theend".localize
        super.awakeFromNib()
    }
}
