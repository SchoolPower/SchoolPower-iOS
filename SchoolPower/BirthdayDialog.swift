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
    
        let lottie = LOTAnimationView(name: "gift_box")
        
        view.viewWithTag(1)!.setNeedsLayout()
        view.viewWithTag(1)!.layoutIfNeeded()
        
        lottie.frame.size.width = view.viewWithTag(1)!.frame.size.width
        lottie.frame.size.height = view.viewWithTag(1)!.frame.size.height
        lottie.contentMode = .scaleAspectFit
        lottie.frame.origin.x = 0
        lottie.frame.origin.y = view.viewWithTag(1)!.frame.origin.y
        lottie.loopAnimation = false
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
