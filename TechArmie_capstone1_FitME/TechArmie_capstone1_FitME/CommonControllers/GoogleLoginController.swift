//
//  GoogleLoginController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    fileprivate weak var contentViewController:UIViewController!
    fileprivate var hasAuthInKeychain: Bool {
        let hasAuth = GIDSignIn.sharedInstance.hasPreviousSignIn()
        return hasAuth
    }
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    var success : ((_ googleUser : GoogleUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    
    private override init() {}
    
    func handleUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool{
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - Method for google login...
    // MARK: ============================
    
    func loginWithGoogle(fromViewController viewController : UIViewController,
               success : @escaping(_ googleUser : GoogleUser) -> (),
               failure : @escaping(_ error : Error) -> ()) {
        
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        if hasAuthInKeychain {
            GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController)
            
            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
                
                if let error = error {
                    
                    // ...
                    failure(error)
                    return
                }
                
                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        let authError = error as NSError
                        if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                            // The user is a multi-factor user. Second factor challenge is required.
                            let resolver = authError
                                .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                            var displayNameString = ""
                            for tmpFactorInfo in resolver.hints {
                                displayNameString += tmpFactorInfo.displayName ?? ""
                                displayNameString += " "
                            }
                            viewController.showTextInputPrompt(
                                withMessage: "Select factor to sign in\n\(displayNameString)",
                                completionBlock: { userPressedOK, displayName in
                                    var selectedHint: PhoneMultiFactorInfo?
                                    for tmpFactorInfo in resolver.hints {
                                        if displayName == tmpFactorInfo.displayName {
                                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                                        }
                                    }
                                    PhoneAuthProvider.provider()
                                        .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                                           multiFactorSession: resolver
                                            .session) { verificationID, error in
                                                if error != nil {
                                                    printDebug(
                                                        "Multi factor start sign in failed. Error: \(error.debugDescription)"
                                                    )
                                                } else {
                                                    viewController.showTextInputPrompt(
                                                        withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                                        completionBlock: { userPressedOK, verificationCode in
                                                            let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                                                .credential(withVerificationID: verificationID!,
                                                                            verificationCode: verificationCode!)
                                                            let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                                                .assertion(with: credential!)
                                                            resolver.resolveSignIn(with: assertion!) { authResult, error in
                                                                if error != nil {
                                                                    printDebug(
                                                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                                                    )
                                                                } else {
                                                                    viewController.navigationController?.popViewController(animated: true)
                                                                }
                                                            }
                                                        }
                                                    )
                                                }
                                            }
                                }
                            )
                        } else {
                            viewController.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        // ...
                        return
                    }
                    // User is signed in
                    // ...
                    let googleUser = GoogleUser(user)
                    //                    self.currentGoogleUser = googleUser
                    success(googleUser)
                }
                // ...
            }
        }
        contentViewController = viewController
        self.success = success
        self.failure = failure
        
    }
    
    func loginWithEmail(
        email: String,
        password: String,
        success : @escaping(_ user : FirebaseAuth.User) -> (),
        failure : @escaping(_ error : Error) -> ()) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard let user = authResult?.user else { failure(error!); return }
                let db = Firestore.firestore().collection("users");
                db.document(user.uid).getDocument(completion: { data, error in
                    if error != nil {
                        return;
                    }
                    if data == nil {
                        return;
                    }
                    if let data = data {
                        do {
                            try AuthUser(data.toObject()).saveToUserDefaults();
                            success(user)
                        } catch {
                            print(error)
                        }
                    }
                })
            }
        }
    
    func signUpWithEmail(
        email: String,
        password: String,
        name: String,
        success : @escaping(_ user : FirebaseAuth.User) -> (),
        failure : @escaping(_ error : Error) -> ()) {
            Auth.auth().createUser(withEmail: email, password: password) {authResult,error in
                guard let user = authResult?.user else { failure(error!); return }
                let changeRequest = user.createProfileChangeRequest();
                changeRequest.displayName = name
                changeRequest.photoURL = NSURL(string: "https://via.placeholder.com/150.png/26424C/FFFFFF?text=" + name.prefix(1)) as URL?
                changeRequest.commitChanges { error1 in
                    if let error1 = error1 {
                        failure(error1);
                    } else {
                        guard let user = authResult?.user else { failure(error!); return }
                        let authModel = AuthUser(AppUserDefaults.value(forKey: .fullUserProfile));
                        authModel.email = email;
                        authModel.name = name;
                        if let url = user.photoURL {
                            authModel.profileImage = url.absoluteString;
                        }
                        authModel.saveToUserDefaults();
                        let db = Firestore.firestore().collection("users");
                        db.document(user.uid)
                            .setData(AppUserDefaults.value(forKey: .fullUserProfile).rawValue as! [String : Any]);
                        db.document(user.uid).getDocument(completion: { data, error in
                            if error != nil {
                                return;
                            }
                            if data == nil {
                                return;
                            }
                            if let data = data {
                                do {
                                    try AuthUser(data.toObject()).saveToUserDefaults();
                                    success(user)
                                } catch {
                                    print(error)
                                }
                            }
                        })
                    }
                }
                
            }
        }
    
    func listenerToCheckIfAuthenticationStateChanged() -> Bool{
        
        var isLoggedIn: Bool = AppUserDefaults.value(forKey: .firebaseSessionToken).boolValue
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            if let _ = user {
                // User is signed in
                AppUserDefaults.save(value: true, forKey: .firebaseSessionToken)
                isLoggedIn = true
                
            } else {
                // user is not signed in
                AppUserDefaults.save(value: false, forKey: .firebaseSessionToken)
                isLoggedIn = false
            }
            
        }
        
        return isLoggedIn
    }
    
    func removeStateChangeListener(){
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func logout(){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance.signOut()
        
    }
    
    func sendForgotPasswordLink(email: String, fromViewController viewController : UIViewController,
                                success : @escaping() -> (),
                                error : @escaping() -> ()) {
        let firebaseAuth = Auth.auth();
        firebaseAuth.sendPasswordReset(withEmail: email) { e in
            if e != nil {
                viewController.showMessagePrompt(e!.localizedDescription)
                error();
                return;
            }
            success();
        }
    }
    
}

class GoogleUser {
    
    let id: String
    let name: String
    let email: String
    let image: URL?
    
    init(_ googleUser: GIDGoogleUser?) {
        
        id = googleUser?.userID ?? ""
        name = googleUser?.profile?.name ?? ""
        email = googleUser?.profile?.email ?? ""
        image = googleUser?.profile?.imageURL(withDimension: 200)
    }
    
    init(_ googleUser: User?) {
        
        id = googleUser?.uid ?? ""
        name = googleUser?.displayName ?? ""
        email = googleUser?.email ?? ""
        image = googleUser?.photoURL
    }
    
    var dictionaryObject: [String:Any] {
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["image"]     = image?.absoluteString ?? ""
        dictionary["name"]      = name
        return dictionary
    }
}


