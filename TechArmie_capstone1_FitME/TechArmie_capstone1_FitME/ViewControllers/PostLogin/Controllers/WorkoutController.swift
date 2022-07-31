//
//  WorkoutController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Swapnil Kumbhar on 2022-07-26.
//

import Foundation
import UIKit
import SwiftUI

class WorkoutController: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: WorkoutView(controller: self));
        addChild(childView);
        childView.view.frame = view.bounds;
        view.addSubview(childView.view);
    }
}
