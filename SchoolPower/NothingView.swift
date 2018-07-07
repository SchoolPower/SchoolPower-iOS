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
