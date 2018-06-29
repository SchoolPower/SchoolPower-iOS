//
//  Copyright 2018 SchoolPower Studio

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
