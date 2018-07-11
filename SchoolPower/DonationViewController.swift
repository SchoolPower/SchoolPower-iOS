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
import XLPagerTabStrip
import MaterialComponents

class DonationViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var wechatCard: MDCCard!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "donation".localize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTheView),
                                               name:NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTheme"), object: nil)
    }
      
    override func viewDidLoad() {
        loadTheView()
    }
    @IBAction func alipayOnClick(_ sender: Any)  {
        UIApplication.shared.openURL(NSURL(string: "alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https://qr.alipay.com/tsx09230fuwngogndwbkg3b")! as URL)
    }
    
    @IBAction func weChatOnClick(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(#imageLiteral(resourceName: "wechat_qr"), nil, nil, nil)
        UIApplication.shared.openURL(NSURL(string: "weixin://scanqrcode")! as URL)
    }
    
    @objc func loadTheView() {
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.windowBackgroundColor
        
    }
}
