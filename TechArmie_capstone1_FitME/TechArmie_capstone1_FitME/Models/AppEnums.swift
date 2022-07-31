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

// TODO: Remove if extra
//MARK:- Api Code
//=======================
enum ApiCode {
    
    static var success: Int { return 200 } // Success
    static var successButNotVerified : Int {return 201} //successButNotVerified
    
    static var unauthorizedRequest: Int { return 401 } // Unauthorized request
    static var headerMissing: Int { return 207 } // Header is missing
    static var phoneNumberAlreadyExist: Int { return 208 } // Phone number alredy exists
    static var requiredParametersMissing: Int { return 418 } // Required Parameter Missing or Invalid
    static var fileUploadFailed: Int { return 421 } // File Upload Failed
    static var pleaseTryAgain: Int { return 500 } // Please try again
    static var tokenExpired: Int { return 401 } // Token expired refresh token needed to be generated
    static var userBlocked: Int { return 428 } // User Blocked
    static var userDeleted: Int { return 450 } // User Deleted
    static var subscriptionExpired : Int {return 460}

    /*
     200 => success
     201 => Success, But Required some action
     
     500 =>Internal Server Error
     501 =>Something Went Wrong
     401 =>Unauthorized
     405 =>Invalid parameters in request/Param Missing
     420 =>Invalid Credentials
     404 =>User not found
     421 =>Email is already registered
     422 =>Email is already registered with some other facebook account
     423 =>Email is already registered with some other gmail account
     425 =>Invalid reset token provided
     427 =>Invalid User Id
     428 =>User is blocked
     429 =>Your account has been registered socially with the app
     450 =>User Deleted
     201 =>User is not verified
 */
}
