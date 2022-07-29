//
//  UIApplicationExtention.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-24.
//

import Foundation
import UIKit

extension UIApplication {

    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    public static var topMostVC: UIViewController? {
        let topVC = topViewController()
        if topVC == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return topVC
    }
}
