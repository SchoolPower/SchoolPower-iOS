//
//  Copyright 2019 SchoolPower Studio
//

import UIKit

class CourseDetailFooterCell: UITableViewCell {
    
    @IBOutlet weak var theEnd: UILabel?
    
    override func awakeFromNib() {
        
//        theEnd?.text = "theend".localize
        theEnd?.text = ""
        super.awakeFromNib()
    }
}
