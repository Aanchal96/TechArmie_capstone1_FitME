//
//  AppUserDefaults.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

//TODO: Verify extensions
import Foundation
import UIKit

 extension NSObject{
    
    ///Retruns the name of the class
    class var className: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    ///Retruns the name of the class
    var className: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
