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
import MaterialComponents

class CryptoDialog: UIView {
    
    enum CryptoType: Int {
        case BITCOIN = 1, ETHEREUM = 2
    }
    
    class func instanceFromNib(width: CGFloat = 10, cryptoType: CryptoType) -> UIView {
        
        let view = UINib(nibName: "CryptoDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        let theme = ThemeManager.currentTheme()
        
        var address = ""
        switch cryptoType {
        case CryptoType.BITCOIN: address = BITCOIN_ADDRESS
        case CryptoType.ETHEREUM: address = ETHEREUM_ADDRESS
        }
        
        var title = ""
        switch cryptoType {
        case CryptoType.BITCOIN: title = "donate_via_bitcoin".localize
        case CryptoType.ETHEREUM: title = "donate_via_eth".localize
        }
        
        view.backgroundColor = theme.windowBackgroundColor
        view.bounds.size.width = width
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        (view.viewWithTag(2) as! MDCCard).backgroundColor = .white
        (view.viewWithTag(3) as! UIImageView).image = Utils.generateQRCode(from: address)
        
        (view.viewWithTag(4) as! MDCCard).backgroundColor = theme.cardBackgroundColor
        (view.viewWithTag(5) as! UILabel).text = address
        (view.viewWithTag(5) as! UILabel).textColor = theme.primaryTextColor
        (view.viewWithTag(6) as! UILabel).text = title
        (view.viewWithTag(6) as! UILabel).textColor = theme.primaryTextColor
        
        view.viewWithTag(1)?.setNeedsLayout()
        view.viewWithTag(1)?.layoutIfNeeded()
        
        view.bounds.size.height = (view.viewWithTag(1)?.bounds.size.height)!
        
        return view
    }
}
