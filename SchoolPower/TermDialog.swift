//
//  GPADialogView.swift
//  SchoolPower
//
//  Created by carbonyl on 2017-12-09.
//  Copyright © 2017 carbonylgroup.studio. All rights reserved.
//


import UIKit
import MKRingProgressView
import SACountingLabel

class TermDialog: UIView {
    
    class func instanceFromNib(width: CGFloat = 10, name: String, subject: String, grade: Grade) -> UIView {
        
        let view = UINib(nibName: "TermDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        view.bounds.size.width = width
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        (view.viewWithTag(1) as? UILabel)?.text = name
        (view.viewWithTag(2) as? UILabel)?.text = subject
        (view.viewWithTag(3) as? UILabel)?.text = grade.percentage
        (view.viewWithTag(5) as? UILabel)?.text = (grade.evaluation == "--") ? "N/A" : String(format: "%@ (%@)", grade.evaluation, Utils.citizenshipCode[grade.evaluation]!)
        (view.viewWithTag(7) as? UILabel)?.text = (grade.comment == "") ? "N/A" : grade.comment
        (view.viewWithTag(4) as? UILabel)?.text = "evaluation".localize
        (view.viewWithTag(6) as? UILabel)?.text = "comment".localize
        view.viewWithTag(11)?.backgroundColor = Utils.getColorByGrade(item: grade)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.bounds.size.height = ((view.viewWithTag(8))?.height)!
        
        let evalCard = view.viewWithTag(9)
        let commentCard = view.viewWithTag(10)
        evalCard?.layer.cornerRadius = 5
        evalCard?.layer.shouldRasterize = true
        evalCard?.layer.rasterizationScale = UIScreen.main.scale
        evalCard?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        evalCard?.layer.shadowRadius = 1
        evalCard?.layer.shadowOpacity = 0.2
        commentCard?.layer.cornerRadius = 5
        commentCard?.layer.shouldRasterize = true
        commentCard?.layer.rasterizationScale = UIScreen.main.scale
        commentCard?.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        commentCard?.layer.shadowRadius = 1
        commentCard?.layer.shadowOpacity = 0.2
        
        return view
    }
}

