//
//  AppSettingsViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Macbbok Pro on 2022-07-29.
//

import UIKit
import SwiftUI

class AppSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: AppSettingsView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);

    }
    

    
}
