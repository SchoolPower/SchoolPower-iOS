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
import PocketSVG
import MaterialComponents

class InListDialog: UIView {
    
    class func instanceFromNib(
        imageURL: URL,
        title: String,
        message: String,
        primaryText: String,
        secondaryText: String,
        dismissText: String
        ) -> UIView {
        
        let theme = ThemeManager.currentTheme()
        let accent = Utils.getAccent()
        let view = UINib(nibName: "InListDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        view.backgroundColor = theme.windowBackgroundColor
        
        let card = (view.viewWithTag(1) as! TouchThroughCard)
        card.backgroundColor = theme.cardBackgroundColor
        card.cornerRadius = 10
        card.inkView.isHidden = true
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .normal)
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .highlighted)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        
        let svgImageView = SVGImageView.init(contentsOf: imageURL)
        svgImageView.frame = (view.viewWithTag(10)?.frame)!
        svgImageView.contentMode = .scaleAspectFit
        svgImageView.clipsToBounds = true
        svgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.viewWithTag(10)?.addSubview(svgImageView)
        
        (view.viewWithTag(2) as! UILabel).text = title
        (view.viewWithTag(2) as! UILabel).textColor = accent
        (view.viewWithTag(3) as! UILabel).text = message
        (view.viewWithTag(3) as! UILabel).textColor = theme.primaryTextColor
        
        let primaryButton = (view.viewWithTag(4) as! MDCFlatButton)
        let secondaryButton = (view.viewWithTag(5) as! MDCFlatButton)
        let dismissButton = (view.viewWithTag(6) as! MDCFlatButton)
        
        let title = primaryButton.attributedTitle(for: .normal)!
        title.setValue(primaryText, forKey: "string")
        primaryButton.setAttributedTitle(title, for: .normal)
        primaryButton.titleLabel?.textColor = accent
        primaryButton.backgroundColor = .clear
        primaryButton.inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        title.setValue(secondaryText, forKey: "string")
        secondaryButton.setAttributedTitle(title, for: .normal)
        secondaryButton.titleLabel?.textColor = accent
        secondaryButton.backgroundColor = .clear
        secondaryButton.inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        title.setValue(dismissText, forKey: "string")
        dismissButton.setAttributedTitle(title, for: .normal)
        dismissButton.titleLabel?.textColor = theme.primaryTextColor
        dismissButton.backgroundColor = .clear
        dismissButton.inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        return view
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
    }
}
