//
//  SignUpController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-21.
//

import Foundation
import UIKit
import SwiftUI


class SignUpController: UIViewController {
    
    @IBOutlet weak var theContainer: UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: SignUp(controller: self));
        addChild(childView);
        childView.view.frame = theContainer.bounds;
        theContainer.addSubview(childView.view);
    }
    
    
    func googleSignInButton() {
        
        GoogleLoginController.shared.login(fromViewController: self) { googleUser in
            print("\(googleUser.email ?? "")")
        } failure: { error in
            print("Failure")
        }
        
    }
    
    func emailPasswordFirebaseLogin(email: String, password: String) {
        GoogleLoginController.shared.loginWithEmail(email: email, password: password) { user in
            print(user.displayName!);
        } failure: { error in
            print(error)
        }
    }

}
