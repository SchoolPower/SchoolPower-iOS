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
        
        let theme = ThemeManager.currentTheme()
        let view = UINib(nibName: "GPADialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.bounds.size.width = width
        view.bounds.size.height = width * 1.5
        view.backgroundColor = theme.windowBackgroundColor
        ring = view.viewWithTag(1) as? MKRingProgressGroupView
        percentageLabel = view.viewWithTag(3) as? SACountingLabel
        descriptionLabel = view.viewWithTag(4) as? UILabel
        
        descriptionLabel?.text = "gpamessage".localize
        descriptionLabel?.textColor = theme.primaryTextColor
        percentageLabel?.textColor = theme.primaryTextColor
        (view.viewWithTag(5) as! UIButton).setTitleColor(theme.primaryTextColor, for: .normal) 
        (view.viewWithTag(6) as! UILabel).textColor = theme.primaryTextColor
        
        return view
    }
}
