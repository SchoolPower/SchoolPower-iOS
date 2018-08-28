//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import XLPagerTabStrip

class PromotionViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var androidSegmented: UISegmentedControl!
    
    func setQRAtPosition(position: Int) {
        switch position {
        case 0: QRImageView.image = Utils.generateQRCode(from: ANDROID_DOWNLOAD_ADDRESS)
        case 1: QRImageView.image = Utils.generateQRCode(from: IOS_DOWNLOAD_ADDRESS)
        default: QRImageView.image = Utils.generateQRCode(from: ANDROID_DOWNLOAD_ADDRESS)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "promotion".localize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    @IBAction func androidSegmentChanges(_ sender: UISegmentedControl) {
        setQRAtPosition(position: sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        loadTheView()
    }
    
    @objc func loadTheView() {
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.windowBackgroundColor
        let accent = Utils.getAccent()
        androidSegmented.tintColor = accent
        androidSegmented.borderColor = accent
        setQRAtPosition(position: androidSegmented.selectedSegmentIndex)
    }
}
