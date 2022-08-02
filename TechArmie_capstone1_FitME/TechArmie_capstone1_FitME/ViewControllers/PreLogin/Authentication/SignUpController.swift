//
//  SignUpController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-21.
//

import Foundation
import UIKit
import SwiftUI


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
    
    func emailPasswordFirebaseLogin(email: String, password: String, name: String) {
        GoogleLoginController.shared.signUpWithEmail(email: email, password: password, name: name) { user in
            
            let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } failure: { error in
            CommonFunctions.showToast(error.localizedDescription)
        }
    }

}
