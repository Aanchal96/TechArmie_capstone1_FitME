//
//  UIDeviceExtension.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-24.
//

import Foundation
import UIKit

extension UIDevice {
    
    static let size = UIScreen.main.bounds.size
    
    static let height = UIScreen.main.bounds.height
    
    static let width = UIScreen.main.bounds.width

    @available(iOS 11.0, *)
    static var bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom

    @available(iOS 11.0, *)
    static let topSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.top
    
    static func vibrate() {
        let feedback = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feedback.prepare()
        feedback.impactOccurred()
    }
}
