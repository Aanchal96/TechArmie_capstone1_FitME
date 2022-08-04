//
//  AppSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-01.
//

import UIKit
//import SwiftUI

class AppSettingViewController: UIViewController {

    @IBOutlet weak var accountSettingView: UIView!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapsOnView()
//        let childView = UIHostingController(rootView: AppSettingView(controller: self));
//        addChild(childView);
//        childView.view.frame = view.bounds;
//        view.addSubview(childView.view);
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
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
    
    @objc func accountSettingTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = AccountSettingViewController.instantiate(fromAppStoryboard: .Account)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func share(tapGestureRecognizer: UITapGestureRecognizer) {
        let firstActivityItem = "Share FitMe with loved ones 🚴🏻‍♀️🏊🏻‍♀️🏋🏻‍♀️🧘🏻‍♀️🤸🏻🎉 \n\n\n https://fitme.test-project.link/share.html"
        let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
        activityViewController.popoverPresentationController?.sourceView = shareView
            
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
        ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook,
        ]
            
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension AppSettingViewController{
    func addTapsOnView(){
        let accountSettingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accountSettingTap(tapGestureRecognizer:)))
        
        accountSettingView.isUserInteractionEnabled = true
        accountSettingView.addGestureRecognizer(accountSettingTapGestureRecognizer)
        
        let shareTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(share(tapGestureRecognizer:)))
        shareView.isUserInteractionEnabled = true;
        shareView.addGestureRecognizer(shareTapGestureRecognizer)
    }
}
