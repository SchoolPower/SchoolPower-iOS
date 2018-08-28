//
//  Copyright 2018 SchoolPower Studio
//

import UIKit

class NothingView: UIView {
    
    class func instanceFromNib(width: CGFloat = 0, height: CGFloat = 0, image: UIImage, text: String) -> UIView {
        
        let view = UINib(nibName: "NothingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.bounds.size.width = width
        view.bounds.size.height = height
        (view.viewWithTag(1) as? UILabel)?.text = text
        (view.viewWithTag(1) as? UILabel)?.textColor = ThemeManager.currentTheme().secondaryTextColor
        (view.viewWithTag(2) as? UIImageView)?.image = image
        return view
    }
}
