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
    
    func emailPasswordFirebaseLogin(email: String, password: String, name: String) {
        GoogleLoginController.shared.signUpWithEmail(email: email, password: password, name: name) { user in
            print(user.displayName!);
            let vc = HomeController.instantiate(fromAppStoryboard: .Home)
            self.navigationController?.pushViewController(vc, animated: true)
        } failure: { error in
            print(error)
        }
    }

}
