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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
