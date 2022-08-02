//
//  AppSettingViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-08-01.
//

import UIKit
import SwiftUI

class AppSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: AppSettingView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);
        // Do any additional setup after loading the view.
    }
}
