//
//  Copyright 2019 SchoolPower Studio
//

import UIKit
import Lottie
import MaterialComponents

class BirthdayDialog: UIView {
    
    class func instanceFromNib(width: CGFloat = 10) -> UIView {
        
        let view = UINib(nibName: "BirthdayDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        let theme = ThemeManager.currentTheme()
        
        view.backgroundColor = theme.windowBackgroundColor
        view.bounds.size.width = width
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    
        let lottie = AnimationView(name: "gift_box")
        
        view.viewWithTag(1)!.setNeedsLayout()
        view.viewWithTag(1)!.layoutIfNeeded()
        
        lottie.frame.size.width = view.viewWithTag(1)!.frame.size.width
        lottie.frame.size.height = view.viewWithTag(1)!.frame.size.height
        lottie.contentMode = .scaleAspectFit
        lottie.frame.origin.x = 0
        lottie.frame.origin.y = view.viewWithTag(1)!.frame.origin.y
        lottie.loopMode = .playOnce
        view.addSubview(lottie)
        lottie.play()
        
        (view.viewWithTag(2) as! UILabel).textColor = Utils.getAccent()
        (view.viewWithTag(3) as! UILabel).textColor = theme.primaryTextColor
        (view.viewWithTag(2) as! UILabel).text = String(format: "happy_birth_title_builder".localize, Utils.getAge(withSuffix: DGLocalization.sharedInstance.getCurrentLanguage().languageCode == "en"))
        (view.viewWithTag(3) as! UILabel).text = "happy_birth_message".localize
        (view.viewWithTag(5) as! MDCFlatButton).setTitle("happy_birth_thank".localize, for: .normal)
        (view.viewWithTag(5) as! MDCFlatButton).setTitleColor(Utils.getAccent(), for: .normal)
        (view.viewWithTag(5) as! MDCFlatButton).inkColor = theme.primaryTextColor.withAlphaComponent(0.1)
        
        view.viewWithTag(4)?.setNeedsLayout()
        view.viewWithTag(4)?.layoutIfNeeded()
        
        view.bounds.size.height = (view.viewWithTag(4)?.bounds.size.height)!
        
        return view
    }
}
