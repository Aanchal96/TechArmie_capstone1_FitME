//
//  AppSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-01.
//

import UIKit
import SwiftUI

class AppSettingViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let childView = UIHostingController(rootView: AppSettingView(controller: self));
//        addChild(childView);
//        childView.view.frame = view.bounds;
//        view.addSubview(childView.view);
        // Do any additional setup after loading the view.
    }
    
    func logout() {
        GoogleLoginController.shared.logout()
        AppUserDefaults.removeAllValues()
        let vc = OnboardingViewController.instantiate(fromAppStoryboard: .Main)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        nvc.navigationBar.isHidden = true
        nvc.setNavigationBarHidden(true, animated: true)
        AppDelegate.shared.window?.rootViewController = nvc
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
}
