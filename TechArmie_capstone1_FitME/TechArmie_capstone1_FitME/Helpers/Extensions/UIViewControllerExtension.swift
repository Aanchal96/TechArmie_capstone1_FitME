//
//  UIViewControllerExtention.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-24.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import MobileCoreServices
import NVActivityIndicatorView

private class SaveAlertHandle {
    static var alertHandle: UIAlertController?
    
    class func set(_ handle: UIAlertController) {
        alertHandle = handle
    }
    
    class func clear() {
        alertHandle = nil
    }
    
    class func get() -> UIAlertController? {
        return alertHandle
    }
}

extension UIViewController {
    /*! @fn showMessagePrompt
     @brief Displays an alert with an 'OK' button and a message.
     @param message The message to display.
     */
    func showMessagePrompt(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    /*! @fn showTextInputPromptWithMessage
     @brief Shows a prompt with a text field and 'OK'/'Cancel' buttons.
     @param message The message to display.
     @param completion A block to call when the user taps 'OK' or 'Cancel'.
     */
    func showTextInputPrompt(withMessage message: String,
                             completionBlock: @escaping ((Bool, String?) -> Void)) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionBlock(false, nil)
        }
        weak var weakPrompt = prompt
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = weakPrompt?.textFields?.first?.text else { return }
            completionBlock(true, text)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    /*! @fn showSpinner
     @brief Shows the please wait spinner.
     @param completion Called after the spinner has been hidden.
     */
    func showSpinner(_ completion: (() -> Void)?) {
        let alertController = UIAlertController(title: nil, message: "Please Wait...\n\n\n\n",
                                                preferredStyle: .alert)
        SaveAlertHandle.set(alertController)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor(ciColor: .black)
        spinner.center = CGPoint(x: alertController.view.frame.midX,
                                 y: alertController.view.frame.midY)
//        spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin,
//                                    .flexibleLeftMargin, .flexibleRightMargin]
        spinner.startAnimating()
        alertController.view.addSubview(spinner)
        present(alertController, animated: true, completion: completion)
    }
    
    /*! @fn hideSpinner
     @brief Hides the please wait spinner.
     @param completion Called after the spinner has been hidden.
     */
    func hideSpinner(_ completion: (() -> Void)?) {
        if let controller = SaveAlertHandle.get() {
            SaveAlertHandle.clear()
            controller.dismiss(animated: true, completion: completion)
        }
    }
    
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    /// Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
}

extension UIViewController {
    
    typealias ImagePickerDelegateController = (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
    func captureImage(delegate controller: ImagePickerDelegateController,
                      photoGallery: Bool = true,
                      camera: Bool = true,
                      mediaType : [String] = [kUTTypeImage as String] , isRemove : Bool = false , removeBlock : @escaping (_ val : Bool) -> ()) {
        
        let chooseOptionText =  ""
        let alertController = UIAlertController(title: chooseOptionText, message: nil, preferredStyle: .actionSheet)
        
        if photoGallery {
            let chooseFromGalleryText =  LocalizedString.chooseFromGallery.localized
            let alertActionGallery = UIAlertAction(title: chooseFromGalleryText, style: .default) { _ in
                self.checkAndOpenLibrary(delegate: controller, mediaType: mediaType)
            }
            
            alertController.addAction(alertActionGallery)
        }
        
        if camera {
            let takePhotoText =  LocalizedString.takePhoto.localized
            let alertActionCamera = UIAlertAction(title: takePhotoText, style: .default) { action in
                self.checkAndOpenCamera(delegate: controller, mediaType: mediaType)
            }
            alertController.addAction(alertActionCamera)
        }
        if isRemove {
            let remove =  LocalizedString.removePhoto.localized
            let alertActionCamera = UIAlertAction(title: remove, style: .destructive) { action in
                removeBlock(true)
            }
            alertController.addAction(alertActionCamera)
        }
        
        let cancelText =  LocalizedString.cancel.localized
        let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel) { _ in
        }
        alertController.addAction(alertActionCancel)
        alertController.view.tintColor = AppColors.themePrimaryColor
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(delegate controller: ImagePickerDelegateController,mediaType : [String] = [kUTTypeImage as String]) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
            
        case .authorized:
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = 15
            let sourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                imagePicker.sourceType = sourceType
                imagePicker.allowsEditing = true
                
                if imagePicker.sourceType == .camera {
                    imagePicker.showsCameraControls = true
                }
                controller.present(imagePicker, animated: true, completion: nil)
                
            } else {
                let cameraNotAvailableText = LocalizedString.cameraNotAvailable.localized
                self.showAlert(title: LocalizedString.alert.localized, msg: cameraNotAvailableText)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                
                if granted {
                    
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = controller
                        imagePicker.mediaTypes = mediaType
                        imagePicker.videoMaximumDuration = 15
                        
                        let sourceType = UIImagePickerController.SourceType.camera
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            
                            imagePicker.sourceType = sourceType
                            if imagePicker.sourceType == .camera {
                                imagePicker.allowsEditing = true
                                imagePicker.showsCameraControls = true
                            }
                            controller.present(imagePicker, animated: true, completion: nil)
                            
                        } else {
                            let cameraNotAvailableText = LocalizedString.cameraNotAvailable.localized
                            self.showAlert(title: LocalizedString.error.localized, msg: cameraNotAvailableText)
                        }
                    }
                }
            })
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting(LocalizedString.restrictedFromUsingCamera.localized)
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting(LocalizedString.changePrivacySettingAndAllowAccessToCamera.localized)
        }
    }
    
    func checkAndOpenLibrary(delegate controller: ImagePickerDelegateController,mediaType : [String] = [kUTTypeImage as String]) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            imagePicker.mediaTypes = mediaType
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = 15
            
            controller.present(imagePicker, animated: true, completion: nil)
            
        case .restricted:
            alertPromptToAllowCameraAccessViaSetting(LocalizedString.restrictedFromUsingLibrary.localized)
            
        case .denied:
            alertPromptToAllowCameraAccessViaSetting(LocalizedString.changePrivacySettingAndAllowAccessToLibrary.localized)
            
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = controller
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = mediaType
            imagePicker.videoMaximumDuration = 15
            
            controller.present(imagePicker, animated: true, completion: nil)
        default:
            break
//        case .limited:
//            printDebug("limited")
        }
    }
    
    private func alertPromptToAllowCameraAccessViaSetting(_ message: String) {
        
        let alertText = LocalizedString.alert.localized
        let cancelText = LocalizedString.cancel.localized
        let settingsText = LocalizedString.settings.localized
        
        let alert = UIAlertController(title: alertText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: settingsText, style: .default, handler: { (action) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController:UIViewController){
        
        self.addChild(childViewController)
        childViewController.view.frame = self.view.bounds
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParent:Void{
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:UIBarButtonItem? = nil, rightButton:UIBarButtonItem? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedString.Key : Any]? = nil){
        
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor{
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor{
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton{
            self.navigationItem.leftBarButtonItem = button;
        }
        if let button = rightButton{
            self.navigationItem.rightBarButtonItem = button;
        }
        if let ttle = title{
            self.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    //function to pop the target from navigation Stack
    @objc func pop(animated:Bool = true) {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    func popToSpecificViewController(atIndex index:Int, animated:Bool = true) {
        
        if let navVc = self.navigationController, navVc.viewControllers.count > index{
            
            _ = self.navigationController?.popToViewController(navVc.viewControllers[index], animated: animated)
        }
    }
    
    func showAlert( title : String = "", msg : String,_ completion : (()->())? = nil) {
        
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: LocalizedString.ok.localized, style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
            
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = LocalizedString.add.localized,
                         cancelTitle:String? = LocalizedString.cancel.localized,
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        })
        action.isEnabled = false
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                action.isEnabled = textField.text?.checkIfValid(.email) ?? false
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addLeftBarButton(title : String?, titleColor: UIColor, image: UIImage?){
        let leftButton = UIButton(type: .custom)
        if let title = title{
            leftButton.setTitle(title, for: .normal)
        }
        leftButton.setTitleColor(titleColor, for: .normal)
        
        let titleSize = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(28) : CGFloat(17)
        leftButton.titleLabel?.font =  UIFont.init(name: AppFonts.regular.rawValue, size: titleSize)
        if let image = image{
            leftButton.setImage(image, for: .normal)
        }
        leftButton.addTarget(self, action: #selector(leftBarButtonTapped(_:)), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func leftBarButtonTapped(_ sender: UIButton){
        
    }
    
    func addRightBarButton(title : String?, titleColor: UIColor, image: UIImage?){
        let rightButton = UIButton(type: .custom)
        if let title = title{
            rightButton.setTitle(title, for: .normal)
        }
        rightButton.setTitleColor(titleColor, for: .normal)
        
        let titleSize = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(28) : CGFloat(18)
        rightButton.titleLabel?.font =  UIFont.init(name: AppFonts.medium.rawValue, size: titleSize)
        if let image = image{
            rightButton.setImage(image, for: .normal)
        }
        rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped(_ sender: UIButton) {
        
    }
    
    func setupNavigationBar(title: String,
                            titleColor : UIColor = .white,
                            titleImage : UIImage? = nil,
                            backButton: Bool,
                            sideMenu: Bool = false) {
        
        let navButton = UIButton(type: .custom)
        navButton.setTitle(title, for: .normal)
        navButton.setTitleColor(titleColor, for: .normal)

        let titleSize = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(31) : CGFloat(17)
        navButton.titleLabel?.font =  UIFont(name: AppFonts.semibold.rawValue, size: titleSize)
        
        if let titleImage = titleImage {
         navButton.setImage(titleImage, for: .normal)
         navButton.semanticContentAttribute = UIApplication.shared
                .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        }
        navButton.isUserInteractionEnabled = false
        self.navigationItem.titleView = navButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.extendedLayoutIncludesOpaqueBars = true
        
        if backButton {
//                    let leftButton: UIBarButtonItem = UIBarButtonItem(image: PreLoginImages.backButton.image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pop))
//            navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Start Loader
    func startNYLoader() {
        //TODO: Uncomment
//        startAnimating(CGSize(width: 50, height: 50), type: NVActivityIndicatorType.circleStrokeSpin, color: AppColors.themeGreenColor, backgroundColor: AppColors.loaderBkgroundColor)
    }
}

