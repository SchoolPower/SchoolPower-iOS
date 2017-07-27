//
//  GPADialogView.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-07-26.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit
import MKRingProgressView
import SACountingLabel

var ring: MKRingProgressGroupView?
var percentageLabel: SACountingLabel?
var descriptionLabel: UILabel?

class GPADialog: UIView {
    
    class func instanceFromNib(width: CGFloat = 10) -> UIView {
        
        let view = UINib(nibName: "GPADialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.bounds.size.width = width
        view.bounds.size.height = width * 1.5
        ring = view.viewWithTag(1) as? MKRingProgressGroupView
        percentageLabel = view.viewWithTag(3) as? SACountingLabel
        descriptionLabel = view.viewWithTag(4) as? UILabel
        return view
    }
}
