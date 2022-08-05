//
//  SignUpController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-21.
//

import Foundation
import UIKit
import SwiftUI
import AWSS3
import AWSCore
import FirebaseAuth
import FirebaseFirestore


class SignUpController: BaseVC {
    
    @IBOutlet weak var theContainer: UIView!;
    var profileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: SignUp(controller: self));
        addChild(childView);
        childView.view.frame = theContainer.bounds;
        theContainer.addSubview(childView.view);
    }
    
    func privacyPolicy(){
         let vc = PrivacyPolicyViewController.instantiate(fromAppStoryboard: .Account)
         self.navigationController?.pushViewController(vc, animated: true)
     }

     func termsAndConditions(){
         let vc = TermsAndConditionsViewController.instantiate(fromAppStoryboard: .Account)
         self.navigationController?.pushViewController(vc, animated: true)
     }
    
    func emailPasswordFirebaseLogin(email: String, password: String, name: String) {
        GoogleLoginController.shared.signUpWithEmail(email: email, password: password, name: name) { user in
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
    
    func uploadImage(image: UIImage) {
        AWSS3Manager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
                guard let strongSelf = self else { return }
                print(strongSelf)
            }) {[weak self] (uploadedFileUrl, error) in
                guard self != nil else { return }
                if let finalPath = uploadedFileUrl as? String { // 3
                    print(finalPath);
//                    strongSelf.s3UrlLabel.text = "Uploaded file url: " + finalPath
                } else {
                    print("\(String(describing: error?.localizedDescription))") // 4
                }
            }
    }

}
