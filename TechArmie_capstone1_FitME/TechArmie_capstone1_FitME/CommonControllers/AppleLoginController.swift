//
//  AppleLoginController.swift
//  Paradise
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import AuthenticationServices
import UIKit

protocol AppleSignInProtocal: class {
    func getAppleLoginData(loginData: JSONDictionary)
}

class AppleLoginController: NSObject{
    
    weak var delegate : AppleSignInProtocal?
    static let shared = AppleLoginController()
    //============================Apple_Login=========================================
    
    func apploginButton(stackAppleLogin: UIStackView, vc: UIViewController, isLogin: Bool){
        if #available(iOS 13.2, *) {
            let authorizationButton = ASAuthorizationAppleIDButton(type: isLogin ? .signIn : .signUp, style: .black)
            stackAppleLogin.addArrangedSubview(authorizationButton)
              authorizationButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
              AppleLoginController.shared.delegate = vc as? AppleSignInProtocal
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func appleSignInTapped() {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
             let authController = ASAuthorizationController(authorizationRequests: [request])
             authController.presentationContextProvider = self
             authController.delegate = self
             authController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppleLoginController : ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        if let window = AppDelegate.shared.windows{
//            return window
//        }else{
            return UIWindow()
//        }
    }
}


@available(iOS 13.0, *)
extension AppleLoginController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let loginData =  AppleLoginModel(data: appleIDCredential)
            self.delegate?.getAppleLoginData(loginData: loginData.param)
            
        }else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            guard let appleIdCredentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            let loginData =  AppleLoginModel(data: appleIdCredentials)
            self.delegate?.getAppleLoginData(loginData: loginData.param)
            
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            
            printDebug(appleUsername)
            printDebug(applePassword)
        }
    }
}

@available(iOS 13.0, *)
class AppleLoginModel{
    
    let email : String
    let userID : String
    let familyName : String
    let givenName : String
    let nickName : String
    let identityToken :String
    let authorizationCode: String
    
    var param : [String:Any]{
        var paramData = [String:Any]()
        paramData["driver_type"]         = "apple"
        paramData["device_id"]           = DeviceDetail.deviceId
        paramData["name"]                = "\(givenName) \(familyName)"
        paramData["device_token"]        = DeviceDetail.deviceToken
        paramData["email"]               = email
        paramData["social_id"]           = userID
        paramData["account_info"]        = [:]
        return paramData
    }
    
    init(data: ASAuthorizationAppleIDCredential) {
       
        userID = data.user
        email = data.email ?? ""
        givenName = data.fullName?.givenName ?? ""
        familyName = data.fullName?.familyName ?? ""
        nickName = data.fullName?.nickname ?? ""
        if let token = data.identityToken {
            identityToken = String(bytes: token, encoding: .utf8) ?? ""
        }else{
            identityToken = ""
        }
        if let code = data.authorizationCode {
            authorizationCode = String(bytes: code, encoding: .utf8) ?? ""
        }else{
            authorizationCode = ""
        }
    }
}
