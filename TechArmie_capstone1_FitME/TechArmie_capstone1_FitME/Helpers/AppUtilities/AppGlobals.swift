//
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation
import UIKit

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]

/// Print Debug
func printDebug<T>(_ obj : T) {
    #if DEBUG
        print(obj)
    #endif
}
