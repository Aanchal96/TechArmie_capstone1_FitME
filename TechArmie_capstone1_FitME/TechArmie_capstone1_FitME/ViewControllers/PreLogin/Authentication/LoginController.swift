//
//  LoginController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-21.
//

import Foundation
import UIKit
import GoogleSignIn
import SwiftUI

class LoginController: BaseVC {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var theContainer: UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: Login(controller: self));
        addChild(childView);
        childView.view.frame = theContainer.bounds;
        theContainer.addSubview(childView.view);
    }
    
    func googleSignInButton() {
        
        GoogleLoginController.shared.loginWithGoogle(fromViewController: self) { googleUser in
            let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            nvc.setNavigationBarHidden(true, animated: true)
            AppDelegate.shared.window?.rootViewController = nvc
            AppDelegate.shared.window?.makeKeyAndVisible()
        } failure: { error in
            CommonFunctions.showToast(error.localizedDescription)
        }
        
    }
    
    func emailPasswordFirebaseLogin(email: String, password: String) {
        GoogleLoginController.shared.loginWithEmail(email: email, password: password) { user in
            let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true
            nvc.navigationBar.isHidden = true
            nvc.setNavigationBarHidden(true, animated: true)
            AppDelegate.shared.window?.rootViewController = nvc
            AppDelegate.shared.window?.makeKeyAndVisible()
        } failure: { error in
            CommonFunctions.showToast(error.localizedDescription)
        }
    }
}
