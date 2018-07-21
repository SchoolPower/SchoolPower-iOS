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
        let view = UINib(nibName: "DonateDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        view.backgroundColor = theme.windowBackgroundColor
        view.bounds.size.height = (view.viewWithTag(1)?.bounds.height)! + 20
        
        let card = (view.viewWithTag(1) as! MDCCard)
        card.backgroundColor = theme.cardBackgroundColor
        card.cornerRadius = 10
        card.inkView.isHidden = true
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .normal)
        card.setShadowElevation(ShadowElevation(rawValue: 2.5), for: .highlighted)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        card.setShadowColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        
        return view
    }
    
    @objc func gotoDonation() {
        
        dismiss()
    }
    
    @objc func gotoPromotion() {
        
        dismiss()
    }
    
    @objc func dismiss() {
        
    }
}
