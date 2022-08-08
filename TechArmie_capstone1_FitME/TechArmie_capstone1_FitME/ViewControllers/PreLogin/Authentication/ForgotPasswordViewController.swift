//
//  ForgotPasswordViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-04.
//

import UIKit
import SwiftUI

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: ForgotPasswordView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);
    }
    
    func sendPasswordResetLink(email: String, success : @escaping() -> (), completion : @escaping() -> ()) {
        GoogleLoginController.shared.sendForgotPasswordLink(email: email, fromViewController: self) {
            success()
            completion()
        } error: {
            
            completion()
        }
    }

}
