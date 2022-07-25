//
//  LoginController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-21.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func goofleSignInButton(_ sender: GIDSignInButton) {
        
        GoogleLoginController.shared.login(fromViewController: self) { googleUser in
            
            
            print("\(googleUser.email ?? "")")
            
            let vc = SignUpController.instantiate(fromAppStoryboard: .Authentication)
            self.navigationController?.pushViewController(vc, animated: true)
            
        } failure: { error in
            
            print("Failure")
        }
        
    }
}
