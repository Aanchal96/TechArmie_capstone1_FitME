//
//  LocalizedString.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-07-29.
//

import Foundation

enum LocalizedString: String{
    case enterAgeEmpty = "Please enter your age"
    case enterAge = "Please enter your valid age"
    case cm = "cm"
    case ft = "ft"
    case kg = "kg"
    case lbs = "lbs"
    case inch = "inch"
    case yourAge = "Your Age"
    case yourHeight = "Your Height"
    case yourWeight = "Your Weight"
    case yourWeightGoal = "Your Weight Goal"
    case yearsOld = " years old"
    
    case noInternetConnection = "NoInternetConnection"
    case checkConnectionDesc = "checkConnectionDesc"
    case retry = "Retry"
    case error = "Error"
    
    case enterWeight = "Please enter your weight"
    case enterHeight = "Please enter your height"
    case enterWeightGoal = "Please enter weight goal"
    
    case enterValidHeight = "Height must be between 122 to 302 cm"
    case enterValidWeightKg = "Weight must be between 20 to 300 kg"
    case enterValidWeightKgGoal = "Goal Weight must be between 20 to 300 kg"

    case enterValidWeightLbs = "Weight must be between 44 to 661 lbs"
    case enterValidWeightLbsGoal = "Goal Weight must be between 44 to 661 lbs"
    
    case somethingWentWrong = "Something went wrong"
    
    //MARK:- UIViewController Extension
    //=================================
    case chooseOptions = "ChooseOptions"
    case camera = "Camera"
    case cameraNotAvailable = "CameraNotAvailable"
    case chooseImage = "ChooseImage"
    case chooseFromGallery = "ChooseFromGallery"
    case takePhoto = "TakePhoto"
    case cancel = "Cancel"
    case alert = "Alert"
    case settings = "Settings"
    case restrictedFromUsingCamera = "RestrictedFromUsingCamera"
    case changePrivacySettingAndAllowAccessToCamera = "ChangePrivacySettingAndAllowAccessToCamera"
    case restrictedFromUsingLibrary = "RestrictedFromUsingLibrary"
    case changePrivacySettingAndAllowAccessToLibrary = "ChangePrivacySettingAndAllowAccessToLibrary"
    case add            = "Add"
    case removePhoto = "Remove photo"
    
    case ok = "Ok"

    
}

extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}

