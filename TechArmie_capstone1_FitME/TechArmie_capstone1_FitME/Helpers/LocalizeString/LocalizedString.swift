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

