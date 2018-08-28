//
//  Copyright 2018 SchoolPower Studio
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import MaterialComponents
import CropViewController
import VTAcknowledgementsViewController

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UIActionSheetDelegate, UIAlertViewDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate {
    
    let userDefaults = UserDefaults.standard
    var presentFragment: Int?
    
    @IBOutlet weak var viewBackground: UIView?
    @IBOutlet weak var headerBackground: UIView?
    @IBOutlet weak var table: UITableView?
    @IBOutlet weak var headerUsername: UILabel?
    @IBOutlet weak var headerUserID: UILabel?
    @IBOutlet weak var avatarButton: MDCFloatingButton!
    
    var navController: UINavigationController!
    var imagePicker = UIImagePickerController()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        
        let theme = ThemeManager.currentTheme()
        
        headerBackground?.backgroundColor = theme.primaryColor
        viewBackground?.backgroundColor = theme.primaryColor
        
        table?.delegate = self
        table?.dataSource = self
        table?.separatorColor = theme.windowBackgroundColor
        table?.contentInset = UIEdgeInsetsMake(16, 0, 0, 0)
        table?.backgroundColor = theme.windowBackgroundColor
        
        headerUsername?.text = userDefaults.string(forKey: STUDENT_NAME_KEY_NAME)
        headerUserID?.text = "userid".localize + userDefaults.string(forKey: USERNAME_KEY_NAME)!
        
        avatarButton.clipsToBounds = true
        avatarButton.inkColor = UIColor.black.withAlphaComponent(0.1)
        
        DispatchQueue.global(qos:.userInteractive).async {
            self.updateAvatar()
        }
    }
    
    @IBAction func avatarOnClick(_ sender: MDCFloatingButton) {
        
        if (userDefaults.string(forKey: USER_AVATAR_KEY_NAME) != "") {
            let avatarActions = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "cancel".localize, destructiveButtonTitle: nil)
            avatarActions.tag = 1
            avatarActions.addButton(withTitle: "change_avatar".localize)
            avatarActions.addButton(withTitle: "remove_avatar".localize)
            avatarActions.show(in: view)
        } else {
            changeAvatar()
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch actionSheet.tag {
        case 1:
            switch buttonIndex {
            case 1: changeAvatar()
            case 2: removeAvatar()
            default: return
            }
        case 2:
            switch buttonIndex {
            case 1: takePhoto()
            case 2: pickImage()
            default: return
            }
        default: return
        }
    }
    
    func changeAvatar() {
        
        let avatarAgreement = UIAlertController(title: "avatar_agreement_title".localize, message: "avatar_agreement_message".localize, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "avatar_agreement_message".localize,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        avatarAgreement.setValue(messageText, forKey: "attributedMessage")
        avatarAgreement.addAction(UIAlertAction(title: "decline".localize, style: .cancel, handler: { (_) in
            avatarAgreement.dismiss(animated: true, completion: nil)
        }))
        
        avatarAgreement.addAction(UIAlertAction(title: "accept".localize, style: .default, handler: { (_) in
            // Change Avatar
            let imageActions = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "cancel".localize, destructiveButtonTitle: nil)
            imageActions.tag = 2
            imageActions.addButton(withTitle: "take_photo".localize)
            imageActions.addButton(withTitle: "choose_from_album".localize)
            imageActions.show(in: self.view)
        }))
        
        show(avatarAgreement, sender: self)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        cropImage(image: info[UIImagePickerControllerOriginalImage] as! UIImage)
    }
    
    func cropImage(image: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        navController = UINavigationController.init(rootViewController: cropViewController)
        navController.modalTransitionStyle = .coverVertical;
        self.present(navController, animated: true, completion: {})
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage,
                            withRect cropRect: CGRect, angle: Int) {
        uploadAvatar(image: image)
        if navController != nil {
            navController.dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadAvatar(image: UIImage) {
        
        // Compress the image in half in case it's too large
        let data = UIImageJPEGRepresentation(image, 0.5)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data!, withName: "smfile", fileName: "avatar.png", mimeType: "image/png")
        },
            to: IMAGE_UPLOAD_URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let responseJson = JSON.init(data: response.data!)
                        if (responseJson["code"] != "success") {
                            self.closeNavigationDrawer()
                            self.showSnackbar(msg:
                                "avatar_upload_failed".localize
                                    + "\n"
                                    + responseJson["msg"].stringValue)
                            return
                        } else {
                            
                            let avatarUrl = responseJson["data"]["url"].stringValue
                            let username = self.userDefaults.string(forKey: USERNAME_KEY_NAME)
                            let password = self.userDefaults.string(forKey: PASSWORD_KEY_NAME)
                            
                            Utils.sendPost(url: AVATAR_URL, params:
                                "username=\(username!)"
                                    + "&password=\(password!)"
                                    + "&new_avatar=\(avatarUrl)"
                                    + "&remove_code=\(responseJson["data"]["hash"].stringValue)") { (value) in
                                        
                                        let response = value
                                        if response.contains("error") {
                                            DispatchQueue.main.async {
                                                self.showSnackbar(msg: JSON(data:response.data(using: .utf8, allowLossyConversion: false)!)["error"].stringValue)
                                            }
                                        }
                                        
                                        self.userDefaults.set(avatarUrl, forKey: USER_AVATAR_KEY_NAME)
                                        self.updateAvatar()
                            }
                        }
                    }
                case .failure(let encodingError):
                    self.showSnackbar(msg:
                        "avatar_upload_failed".localize
                            + "\n"
                            + encodingError.localizedDescription)
                }
        })
    }
    
    func removeAvatar() {
        
        let username = userDefaults.string(forKey: USERNAME_KEY_NAME)
        let password = userDefaults.string(forKey: PASSWORD_KEY_NAME)
        
        Utils.sendPost(url: AVATAR_URL, params:
            "username=\(username!)"
                + "&password=\(password!)"
                + "&new_avatar="
                + "&remove_code=") { (value) in
                    
                    let response = value
                    if response.contains("NETWORK_ERROR") {
                        DispatchQueue.main.async {
                            self.showSnackbar(msg: "cannot_connect".localize)
                        }
                        return
                    }
                    if response.contains("error") {
                        DispatchQueue.main.async {
                            self.showSnackbar(msg: JSON(data:response.data(using: .utf8, allowLossyConversion: false)!)["error"].stringValue)
                        }
                    } else {
                        self.userDefaults.set("", forKey: USER_AVATAR_KEY_NAME)
                        self.updateAvatar()
                    }
                    
        }
    }
    
    func updateAvatar() {
        let avatarURL = userDefaults.string(forKey: USER_AVATAR_KEY_NAME)
        var avatar = #imageLiteral(resourceName: "ic_launcher-web")
        if avatarURL != "" {
            let url = URL(string: avatarURL!)
            let data: Data
            do {
                try data = Data(contentsOf: url!)
                avatar = UIImage(data: data)!
            } catch {
                self.showSnackbar(msg: "cannot_load_avatar".localize)
            }
        }
        DispatchQueue.main.async {
            self.avatarButton.setBackgroundImage(avatar, for: .normal)
            self.avatarButton.setNeedsDisplay()
        }
    }
    
    func showSnackbar(msg: String) {
        
        let message = MDCSnackbarMessage()
        message.text = msg
        message.duration = 2    // 2s
        MDCSnackbarManager.show(message)
    }
    
    func reloadData() {
        setup()
        table?.reloadData()
    }
    
    func confirmLogOut() {
        
        let alert = UIAlertController.init(title: "logging_out".localize, message: "sure_to_log_out".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "logout".localize, style: .destructive) { (action:UIAlertAction!) in
            self.logOut()
        })
        alert.addAction(UIAlertAction.init(title: "dont".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func logOut() {
        
        userDefaults.set(false, forKey: LOGGED_IN_KEY_NAME)
        Utils.saveHistoryGrade(data: nil)
        Utils.saveStringToFile(filename: JSON_FILE_NAME, data: "")
        startLoginController()
    }
    
    func startLoginController() {
        
        UIApplication.shared.delegate?.window??.rootViewController!.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login"), animated: true, completion: updateRootViewController)
    }
    
    func updateRootViewController() {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let loginController = story.instantiateViewController(withIdentifier: "login")
        UIApplication.shared.delegate?.window??.rootViewController = loginController
    }
}

//MARK: Drawer
extension LeftViewController {
    @objc
    func gotoFragment(section: Int, location: Int) {
        
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let settingsStory = UIStoryboard(name: "Settings", bundle: nil)
        
        if section == 0 {
            switch location {
                
            case 0:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "DashboardNav"), duration: 0, options: [], animations: nil, completion: nil)
            case 1:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "ChartsNav"), duration: 0, options: [], animations: nil, completion: nil)
            case 2:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "AttendanceNav"), duration: 0, options: [], animations: nil, completion: nil)
            default:
                navigationDrawerController?.transition(to: mainStory.instantiateViewController(withIdentifier: "DashboardNav"), duration: 0, options: [], animations: nil, completion: nil)
            }
            
        } else {
            switch location {
                
            case 0:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(settingsStory.instantiateViewController(withIdentifier: "Settings"), animated: true)
            case 1:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(mainStory.instantiateViewController(withIdentifier: "Support Us"), animated: true)
            case 2:
                (navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(mainStory.instantiateViewController(withIdentifier: "About"), animated: true)
            case 3:
                confirmLogOut()
                
            default:
                print("NoViewToGoTo")
            }
        }
        closeNavigationDrawer()
    }
    
    public func closeNavigationDrawer() {
        navigationDrawerController?.closeLeftView()
    }
}

//MARK: Table View
extension LeftViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "DrawerHeaderCell")
            headerCell?.contentView.viewWithTag(1)?
                .backgroundColor = ThemeManager.currentTheme().secondaryTextColor.withAlphaComponent(0.5)
            return headerCell
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 { return 20 }
        else { return 0 }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 3
        case 1: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerFragmentCell", for: indexPath) as! DrawerFragmentCell
        cell.section = indexPath.section
        cell.location = indexPath.row
        cell.presentSelected = presentFragment ?? 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! DrawerFragmentCell
        cell.isSelected = false
        if cell.section == 0 {
            presentFragment = cell.location
            tableView.reloadData()
        }
        gotoFragment(section: cell.section, location: cell.location)
    }
}
