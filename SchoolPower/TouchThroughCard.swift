//
//  Copyright 2018 SchoolPower Studio
//
//  Credit: vectorvector

//  https://cocoaheads.tumblr.com/post/2130871776/ignore-touches-to-uiview-subclass-but-not-to-its

import UIKit
import MaterialComponents

class TouchThroughCard: MDCCard {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
    }
}
