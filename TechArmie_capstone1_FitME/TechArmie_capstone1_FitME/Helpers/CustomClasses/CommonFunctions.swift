//
//  CommonFunctions.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import Toast_Swift

class CommonFunctions {

    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, isNative : Bool = false, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.topMostVC?.view.endEditing(true)
            if msg == "PleaseCheckInternetConnection" && !isNative{
                self.showToast(msg)
                return
            }
            let alertViewController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive) { (action : UIAlertAction) -> Void in
                alertViewController.dismiss(animated: true, completion: nil)
                completion?()
            }
            
            alertViewController.addAction(okAction)
            UIApplication.topMostVC?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    static func showToast(_ msg : String){
        DispatchQueue.main.async {
            UIApplication.topMostVC?.view.endEditing(true)
            if let vc = UIApplication.topMostVC{//AppDelegate.shared.window.rootViewController{
                if let controller = vc.presentedViewController{
                    controller.view.makeToast(msg)

                }else{
                    vc.view.makeToast(msg)

                }
            }
        }
    }

    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertActionArray.forEach{ alert.addAction($0) }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func alertForErrorWithTitle(title: String, doneTitle: String , msg : String, selfVC : UIViewController, completion: (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: doneTitle , style: UIAlertAction.Style.cancel) { (_) in
            completion?()
        }
        
        alertController.addAction(action)
        selfVC.present(alertController, animated: true, completion: nil)
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).numberOfLines = 0
        
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).lineBreakMode = .byWordWrapping
    }
    
    //TODO: Add activity loader if required:
    /// Show Activity Loader
    class func showActivityLoader() {
        DispatchQueue.main.async {
            
        }
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
        DispatchQueue.main.async {
            
        }
    }
    
}

extension CommonFunctions{
    
    //Enable IQKeyboard
    class func enableIQKeybaord() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    class func disableIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
