//
//  ChallengeDetailViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-28.
//

import UIKit
import SwiftUI

class ChallengeDetailViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: ChallengeDetailView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);
    }
}
