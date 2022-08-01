//
//  FifthStepVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-07-22.
//

import Foundation
import UIKit
import GoogleSignIn

class FifthStepVC : BaseVC{
    
    var profileModel = ProfileModel()
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        let vc = SignUpController.instantiate(fromAppStoryboard: .Authentication)
        vc.profileModel = profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func googleSignInButton() {
        
        GoogleLoginController.shared.login(fromViewController: self) { googleUser in
            let vc = TabBarVC.instantiate(fromAppStoryboard: .TabBar)
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        } failure: { error in
            CommonFunctions.showToast(error.localizedDescription)
        }
        
    }
}
