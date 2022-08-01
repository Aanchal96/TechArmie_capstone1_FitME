//
//  ChallengesViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-28.
//

import UIKit
import SwiftUI

class ChallengesViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: ChallengesView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);
    }
    
    func goToDetailView() {
        let vc = ChallengeDetailViewController.instantiate(fromAppStoryboard: .Challenges)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
