//
//  DonationDialog.swift
//  SchoolPower
//
//  Created by Carbonyl on 2018/07/19.
//  Copyright © 2018年 carbonylgroup.studio. All rights reserved.
//



import UIKit
import MaterialComponents

class DonationDialog: UIView {
    
    class func instanceFromNib() -> UIView {
        
        let theme = ThemeManager.currentTheme()
        let accent = Colors.accentColors[userDefaults.integer(forKey: ACCENT_COLOR_KEY_NAME)]
        let view = UINib(nibName: "DonateDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        view.backgroundColor = theme.windowBackgroundColor
        
        let card = (view.viewWithTag(1) as! TouchThroughCard)
        card.backgroundColor = theme.cardBackgroundColor
        card.cornerRadius = 10
        card.inkView.isHidden = true
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .normal)
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .highlighted)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        
        (view.viewWithTag(2) as! UILabel).text = "donation_title".localize
        (view.viewWithTag(2) as! UILabel).textColor = accent
        (view.viewWithTag(3) as! UILabel).text = "donation_message".localize
        (view.viewWithTag(3) as! UILabel).textColor = theme.primaryTextColor
        
        let donationButton = (view.viewWithTag(4) as! MDCFlatButton)
        let promotionButton = (view.viewWithTag(5) as! MDCFlatButton)
        let dismissButton = (view.viewWithTag(6) as! MDCFlatButton)
        
        let title = donationButton.attributedTitle(for: .normal)!
        title.setValue("donation_ok".localize, forKey: "string")
        donationButton.setAttributedTitle(title, for: .normal)
        donationButton.titleLabel?.textColor = accent
        donationButton.backgroundColor = .clear
        donationButton.inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        title.setValue("donation_promote".localize, forKey: "string")
        promotionButton.setAttributedTitle(title, for: .normal)
        promotionButton.titleLabel?.textColor = accent
        promotionButton.backgroundColor = .clear
        promotionButton.inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        title.setValue("donation_cancel".localize, forKey: "string")
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
