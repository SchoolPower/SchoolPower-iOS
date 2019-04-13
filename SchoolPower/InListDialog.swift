//
//  Copyright 2019 SchoolPower Studio
//

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
        
        let svgImageView = roundedSVGImageView.init(contentsOf: imageURL)
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

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class roundedSVGImageView: SVGImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
}
