//
//  NothingView.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-08-08.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//

import UIKit

class NothingView: UIView {
    
    class func instanceFromNib(width: CGFloat = 0, height: CGFloat = 0) -> UIView {
        
        let view = UINib(nibName: "NothingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.bounds.size.width = width
        view.bounds.size.height = height
        (view.viewWithTag(1) as? UILabel)?.text = "nothing_here".localize
        return view
    }
}
