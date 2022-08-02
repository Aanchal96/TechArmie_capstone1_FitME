//
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation
import UIKit

enum AppFonts : String {
    
    case regular = "SFProText-Regular"
    case medium = "SFProText-Medium"
    case semibold = "SFProText-Semibold"
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: (fontSize + 4)) ?? UIFont.systemFont(ofSize: (fontSize + 4))
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: (12.0 + 4)) ?? UIFont.systemFont(ofSize: (12.0 + 4))
    }
    
}
