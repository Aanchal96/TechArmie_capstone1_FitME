//
//  AppDelegate.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        setupKeyboard()

        navigateOnAppLaunch()
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    private func setupKeyboard(){
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    }
    
    private func navigateOnAppLaunch() {
        
        let isUserLoggedIn = GoogleLoginController.shared.listenerToCheckIfAuthenticationStateChanged()
        if isUserLoggedIn{
            let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            nvc.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = nvc
            self.window?.makeKeyAndVisible()
        } else {
            let vc = OnboardingViewController.instantiate(fromAppStoryboard: .Main)
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            nvc.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = nvc
            self.window?.makeKeyAndVisible()
        }
    }
}

