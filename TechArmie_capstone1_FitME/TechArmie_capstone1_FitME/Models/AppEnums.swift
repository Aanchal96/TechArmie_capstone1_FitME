//
//  AppEnums.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-30.
//

import Foundation

public enum Gender : String{
    case male = "male"
    case female = "female"
    case other = "other"
}

public enum HeightUnit : String {
    case cm = "cm"
    case ft = "ft"
}

public enum WeightUnit : String {
    case kg = "kg"
    case lbs = "lbs"
}

public enum ProgramLevel : Int{
    case beginner = 1
    case novice = 2
    case intermediate = 3
    case advance = 4
}

public enum Goal : Int{
    case loseWeight  = 1
    case gainWeight = 2
    case beActive = 3
    
    init(val : Int){
        switch val{
        case 3:
            self = .beActive
        case 2:
            self = .gainWeight
        default:
            self = .loseWeight
        }
    }
}
