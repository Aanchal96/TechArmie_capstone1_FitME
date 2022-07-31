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

/// Is Simulator or Device
var isSimulatorDevice: Bool {

    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}

/// Is this iPhone X or not
func isDeviceIsIphoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136: return false
        case 1334: return false
        case 2208: return false
        case 2436: return true
        default: return false
        }
    }
    return false
}


