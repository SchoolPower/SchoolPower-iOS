//
//  Copyright 2018 SchoolPower Studio
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
        
        view.backgroundColor = theme.windowBackgroundColor
        view.bounds.size.width = width
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.bounds.size.width = width
        view.bounds.size.height = width * 1.5
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
