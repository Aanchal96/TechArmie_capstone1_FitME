//
//  DoubleExtension.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-24.
//

import Foundation

extension Double{
    
    func toIntValue() -> Int? {
        let minInt = Double(Int.min)
        let maxInt = Double(Int.max)

        guard case minInt ... maxInt = self else {
            return nil
        }

        return Int(self)
    }
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }

}
