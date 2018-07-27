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
import CustomIOSAlertView
import Photos

class DonationViewController: UIViewController, IndicatorInfoProvider {
    
    var navController: UINavigationController!
    var currentCryptoType = CryptoDialog.CryptoType.BITCOIN
    
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
    @IBAction func alipayOnClick(_ sender: MDCCard)  {
        
        if UIApplication.shared.canOpenURL(NSURL(string: "alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https://qr.alipay.com/tsx09230fuwngogndwbkg3b")! as URL) {
            UIApplication.shared.openURL(NSURL(string: "alipayqr://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https://qr.alipay.com/tsx09230fuwngogndwbkg3b")! as URL)
        } else {
            notifyAlipayUnavailable()
        }
    }
    
    @IBAction func weChatOnClick(_ sender: MDCCard) {
        initWechatInstruction()
    }
    
    @IBAction func paypalOnClick(_ sender: MDCCard) {
        UIApplication.shared.openURL(NSURL(string: PAYPAL_DONATION_URL)! as URL)
    }
    
    @IBAction func bitcoinOnClick(_ sender: MDCCard) {
        currentCryptoType = CryptoDialog.CryptoType.BITCOIN
        showCryptoDialog(cryptoType: currentCryptoType)
    }
    
    @IBAction func ethereumOnClick(_ sender: MDCCard) {
        currentCryptoType = CryptoDialog.CryptoType.ETHEREUM
        showCryptoDialog(cryptoType: currentCryptoType)
    }
    
    func initWechatInstruction() {
        
        let page1 = OnboardingContentViewController(
            title: "wechat_instruction_page1_title".localize,
            body: "wechat_instruction_page1_des".localize,
            image: #imageLiteral(resourceName: "ic_wechat_pay"),
            buttonText: "") {}
        
        let page2 = OnboardingContentViewController(
            title: "",
            body: "wechat_instruction_page2_des".localize,
            image: #imageLiteral(resourceName: "page2"),
            buttonText: "") {}
        
        let page3 = OnboardingContentViewController(
            title: "",
            body: "wechat_instruction_page3_des".localize,
            image: #imageLiteral(resourceName: "page3"),
            buttonText: "") {}
        
        let page4 = OnboardingContentViewController(
            title: "",
            body: "wechat_instruction_page4_des".localize,
            image: #imageLiteral(resourceName: "page4"),
            buttonText: "") {}

        let onboardingVC = InstructionViewController(
            backgroundImage: UIImage.from(color: UIColor.init(rgb: Colors.B_score_green)),
            contents: [
                page1.fitFirst(view: view),
                page2.fitRest(view: view),
                page3.fitRest(view: view),
                page4.fitRest(view: view),
            ]
        )
        
        onboardingVC?.skipButton = MDCButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        onboardingVC?.skipButton.setTitle("skip".localize, for: .normal)
        onboardingVC?.skipButton.titleLabel?.textColor = .white
        onboardingVC?.skipButton.backgroundColor = .clear
        onboardingVC?.skipButton.addTarget(self, action: #selector(gotoWechat), for: .touchUpInside)
        onboardingVC?.okButton = MDCButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        onboardingVC?.okButton.setTitle("ok".localize, for: .normal)
        onboardingVC?.okButton.titleLabel?.textColor = .white
        onboardingVC?.okButton.backgroundColor = .clear
        onboardingVC?.okButton.addTarget(self, action: #selector(gotoWechat), for: .touchUpInside)
        
        onboardingVC?.shouldMaskBackground = false
        onboardingVC?.allowSkipping = true
        onboardingVC?.fadeSkipButtonOnLastPage = true
        onboardingVC?.okHandler = { self.gotoWechat() }
        onboardingVC?.shouldFadeTransitions = true
        
        navController = UINavigationController.init(rootViewController: onboardingVC!)
        navController.modalTransitionStyle = .coverVertical;
        self.navigationController?.present(navController, animated: true, completion: {})
    }
    
    @objc func gotoWechat() {
        
        if UIApplication.shared.canOpenURL(NSURL(string: "weixin://scanqrcode")! as URL) {
            if isPhotoPermissionGranted() {
                UIImageWriteToSavedPhotosAlbum(#imageLiteral(resourceName: "wechat_qr"), nil, nil, nil)
                UIApplication.shared.openURL(NSURL(string: "weixin://scanqrcode")! as URL)
                dissmissInstruction()
            } else {
                dissmissInstruction()
                notifyPermissionNotGranted()
            }
        } else {
            dissmissInstruction()
            notifyWechatUnavailable()
        }
    }
    
    func dissmissInstruction() {
        if navController != nil {
            navController.dismiss(animated: true, completion: {})
        }
    }
    
    func isPhotoPermissionGranted() -> Bool {
        // Get the current authorization state.
        var permission = false
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) { return true }
        else if (status == PHAuthorizationStatus.denied) { return false }
        else if (status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) { permission = true }
            })
        }
        return permission
    }
    
    func updateNavigationBarWithColor(color: UIColor) {
        
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func notifyAlipayUnavailable() {
        
        let alert = UIAlertController.init(title: "cant_open_alipay".localize, message: "AlipayNotFound".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "emm".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func notifyWechatUnavailable() {
        
        let alert = UIAlertController.init(title: "cant_open_wechat".localize, message: "WechatNotFound".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "emm".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func notifyPermissionNotGranted() {
        
        let alert = UIAlertController.init(title: "storage_permission_exp_title".localize, message: "storage_permission_denied".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "emm".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showCryptoDialog(cryptoType: CryptoDialog.CryptoType) {
        
        let standerdWidth = self.view.frame.width * 0.8
        let alert = CustomIOSAlertView.init()
        let cryptoDialog = CryptoDialog.instanceFromNib(width: standerdWidth, cryptoType: cryptoType)
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: standerdWidth, height: cryptoDialog.bounds.size.height))
        (cryptoDialog.viewWithTag(4) as! MDCCard).addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        cryptoDialog.center = subview.center
        subview.addSubview(cryptoDialog)
        alert?.containerView = subview
        alert?.closeOnTouchUpOutside = true
        alert?.buttonTitles = nil
        alert?.show()
    }
    
    @objc func copyAddress() {
        
        var address = ""
        switch currentCryptoType {
        case CryptoDialog.CryptoType.BITCOIN: address = BITCOIN_ADDRESS
        case CryptoDialog.CryptoType.ETHEREUM: address = ETHEREUM_ADDRESS
        }
        UIPasteboard.general.string = address
        self.showSnackbar(msg: "copied".localize)
    }
    
    @objc func loadTheView() {
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.windowBackgroundColor
    }
    
    func showSnackbar(msg: String) {
        
        let message = MDCSnackbarMessage()
        message.text = msg
        message.duration = 2    // 2s
        MDCSnackbarManager.show(message)
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension OnboardingContentViewController {
    
    func fitFirst(view: UIView) -> OnboardingContentViewController {
        self.topPadding = view.bounds.height * 2 / 10
        self.bottomPadding = 20
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconHeight = view.bounds.height * 5 / 10
        self.iconWidth = view.bounds.width * 8 / 10
        self.bodyLabel.font = self.bodyLabel.font.withSize(18.0)
        self.bodyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        return self
    }
    
    func fitRest(view: UIView) -> OnboardingContentViewController {
        self.topPadding = view.bounds.height * 2 / 10
        self.bottomPadding = 20
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconHeight = view.bounds.height * 7 / 10
        self.iconWidth = view.bounds.width * 8 / 10
        self.bodyLabel.font = self.bodyLabel.font.withSize(18.0)
        self.bodyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        return self
    }
}
