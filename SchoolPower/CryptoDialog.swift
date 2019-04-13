//
//  Copyright 2019 SchoolPower Studio
//

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
